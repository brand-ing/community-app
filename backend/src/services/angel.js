import { randomUUID } from 'node:crypto';
import { missingFields } from './intake-schema.js';
export function createAngelService({ getPool, generate }) {
  return {
    async chat(owner, input) {
      const pool = getPool();
      const existing = await pool.query('SELECT * FROM angel_conversations WHERE id=$1 AND owner_sub=$2', [input.conversationId, owner]);
      const row = existing.rows[0];
      if (!row) {
        const other = await pool.query('SELECT id FROM angel_conversations WHERE id=$1', [input.conversationId]);
        if (other.rowCount) throw Object.assign(new Error('Conversation not found.'), { status: 404 });
      }
      const prior = await pool.query('SELECT message,response FROM angel_turns WHERE conversation_id=$1 AND turn_id=$2', [input.conversationId,input.turnId]);
      if (prior.rows[0]) {
        if (prior.rows[0].message !== input.message) throw Object.assign(new Error('A retry must use the same message.'), { status: 409 });
        return prior.rows[0].response;
      }
      const confirmed = await pool.query('SELECT id FROM help_requests WHERE conversation_id=$1 AND owner_sub=$2', [input.conversationId,owner]);
      if (confirmed.rowCount) throw Object.assign(new Error('This request is confirmed. Start a new conversation for another request.'), { status: 409 });
      const history = row?.history ?? [];
      if (history.length >= 40) throw Object.assign(new Error('This conversation is full. Please start another request.'), { status: 400 });
      const inputHistory = [...history, { role: 'user', text: input.message }];
      const output = await generate(inputHistory);
      const response = { ...output, conversationId: input.conversationId, revision: (row?.revision ?? 0) + 1, missingFields: missingFields(output.draft) };
      const client = await pool.connect();
      try {
        await client.query('BEGIN');
        await client.query('INSERT INTO angel_conversations(id,owner_sub) VALUES($1,$2) ON CONFLICT DO NOTHING', [input.conversationId,owner]);
        const locked = (await client.query('SELECT * FROM angel_conversations WHERE id=$1 AND owner_sub=$2 FOR UPDATE', [input.conversationId,owner])).rows[0];
        if (!locked) throw Object.assign(new Error('Conversation not found.'), { status: 404 });
        const duplicate = (await client.query('SELECT message,response FROM angel_turns WHERE conversation_id=$1 AND turn_id=$2', [input.conversationId,input.turnId])).rows[0];
        if (duplicate) {
          if (duplicate.message !== input.message) throw Object.assign(new Error('A retry must use the same message.'), { status: 409 });
          await client.query('COMMIT'); return duplicate.response;
        }
        if (locked.revision !== (row?.revision ?? 0)) throw Object.assign(new Error('Conversation changed. Please retry.'), { status: 409 });
        const saved = await client.query('SELECT id FROM help_requests WHERE conversation_id=$1', [input.conversationId]);
        if (saved.rowCount) throw Object.assign(new Error('This request is already confirmed.'), { status: 409 });
        await client.query('UPDATE angel_conversations SET history=$1,draft=$2,revision=$3,updated_at=now() WHERE id=$4 AND owner_sub=$5', [JSON.stringify([...inputHistory,{ role:'assistant',text:output.assistantMessage }]),JSON.stringify(output.draft),response.revision,input.conversationId,owner]);
        await client.query('INSERT INTO angel_turns(conversation_id,turn_id,message,response) VALUES($1,$2,$3,$4)', [input.conversationId,input.turnId,input.message,JSON.stringify(response)]);
        await client.query('COMMIT'); return response;
      } catch(error) { await client.query('ROLLBACK'); throw error; } finally { client.release(); }
    },
    async confirm(owner, id, revision) {
      const pool = getPool(); const client = await pool.connect();
      try {
        await client.query('BEGIN');
        const row = (await client.query('SELECT * FROM angel_conversations WHERE id=$1 AND owner_sub=$2 FOR UPDATE',[id,owner])).rows[0];
        if (!row) throw Object.assign(new Error('Conversation not found.'), { status: 404 });
        const existing = (await client.query('SELECT * FROM help_requests WHERE conversation_id=$1 AND owner_sub=$2',[id,owner])).rows[0];
        if (existing) { await client.query('COMMIT'); return existing; }
        if (row.revision !== revision) throw Object.assign(new Error('Draft changed. Review the latest draft first.'), { status:409 });
        if (!row.draft || missingFields(row.draft).length) throw Object.assign(new Error('The draft still needs details.'), { status:400 });
        const d = row.draft;
        const request = (await client.query('INSERT INTO help_requests(id,conversation_id,owner_sub,title,description,category,location,timing,support_mode,skills_needed,evidence) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *',[randomUUID(),id,owner,d.title,d.description,d.category,d.location,d.timing,d.supportMode,d.skillsNeeded,JSON.stringify(d.evidence)])).rows[0];
        await client.query('COMMIT'); return request;
      } catch(error) { await client.query('ROLLBACK'); throw error; } finally { client.release(); }
    },
  };
}
