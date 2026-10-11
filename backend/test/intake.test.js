import test from 'node:test';
import assert from 'node:assert/strict';
import {outputSchema,validateEvidence,missingFields,turnSchema} from '../src/services/intake-schema.js';
import {createAngelService} from '../src/services/angel.js';
const empty = {title:null,description:null,category:'unknown',location:null,timing:null,supportMode:'unknown',skillsNeeded:[],evidence:[]};
test('rejects invalid categories and injected owner fields',()=>{
  assert.equal(outputSchema.safeParse({assistantMessage:'Hello',draft:{...empty,category:'invented'}}).success,false);
  assert.equal(outputSchema.safeParse({assistantMessage:'Hello',draft:{...empty,owner_sub:'other'}}).success,false);
  assert.equal(turnSchema.safeParse({conversationId:'invalid',turnId:'invalid',message:''}).success,false);
});
test('requires evidence from user, not assistant or invented quotations',()=>{
  const d={...empty,title:'Garden help',evidence:[{field:'title',quote:'garden'}]};
  assert.throws(()=>validateEvidence(d,[{role:'assistant',text:'garden'}]));
  assert.deepEqual(validateEvidence(d,[{role:'user',text:'Help with my garden'}]),d);
  assert.throws(()=>validateEvidence({...d,evidence:[]},[{role:'user',text:'garden'}]));
});
test('remote request does not require location; in-person does',()=>{
  const d={...empty,title:'Tutor',description:'Math help',category:'tutoring',timing:'next week',supportMode:'remote'};
  assert.deepEqual(missingFields(d),[]);
  assert.deepEqual(missingFields({...d,supportMode:'in_person'}),['location']);
});
test('ownership is checked before generation',async()=>{
  let called=false;
  const pool={query:async(sql)=>({rows:sql.includes('owner_sub')?[]:[{id:'other'}],rowCount:sql.includes('owner_sub')?0:1})};
  const service=createAngelService({getPool:()=>pool,generate:async()=>{called=true;}});
  await assert.rejects(service.chat('user',{conversationId:'other',turnId:'turn',message:'hello'}),{status:404});
  assert.equal(called,false);
});
test('same turn retry returns saved response without another model call',async()=>{
  const response={assistantMessage:'Saved turn'};
  const pool={query:async(sql)=> sql.includes('angel_conversations')?{rows:[{revision:1}],rowCount:1}:{rows:[{message:'hello',response}],rowCount:1}};
  const service=createAngelService({getPool:()=>pool,generate:async()=>{throw new Error('should not call');}});
  assert.deepEqual(await service.chat('user',{conversationId:'id',turnId:'turn',message:'hello'}),response);
  await assert.rejects(service.chat('user',{conversationId:'id',turnId:'turn',message:'changed'}),{status:409});
});
for(const [label,row,revision,status] of [
  ['unowned',undefined,1,404],['stale',{revision:2,draft:empty},1,409],['incomplete',{revision:1,draft:empty},1,400]
]) test(`confirmation rejects ${label} draft and rolls back`,async()=>{
  const statements=[];
  const client={query:async(sql)=>{statements.push(sql);return {rows:sql.includes('angel_conversations')?(row?[row]:[]):[]};},release(){}};
  const service=createAngelService({getPool:()=>({connect:async()=>client}),generate:async()=>{}});
  await assert.rejects(service.confirm('user','id',revision),{status});
  assert.equal(statements.at(-1),'ROLLBACK');
  assert.equal(statements.some(s=>s.startsWith('INSERT')),false);
});

test('confirmation writes the reviewed draft with server-controlled owner and is idempotent',async()=>{
  const d={...empty,title:'Math tutor',description:'Help with math',category:'tutoring',timing:'next week',supportMode:'remote'};
  const row={revision:1,draft:d}; let saved; let insertCount=0; let params;
  const client={query:async(sql,values)=>{
    if(sql.includes('angel_conversations')) return {rows:[row]};
    if(sql.startsWith('SELECT * FROM help_requests')) return {rows:saved?[saved]:[]};
    if(sql.startsWith('INSERT INTO help_requests')) {insertCount++;params=values;saved={id:values[0],owner_sub:values[2],title:values[3]};return {rows:[saved]};}
    return {rows:[]};
  },release(){}};
  const service=createAngelService({getPool:()=>({connect:async()=>client}),generate:async()=>{}});
  const result=await service.confirm('auth0|owner','id',1);
  assert.equal(params[2],'auth0|owner'); assert.equal(params[3],d.title);
  assert.deepEqual(await service.confirm('auth0|owner','id',1),result);
  assert.equal(insertCount,1);
});
