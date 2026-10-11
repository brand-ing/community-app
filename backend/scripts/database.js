import 'dotenv/config';
import { readFile } from 'node:fs/promises';
import { getPool } from '../src/db/pool.js';
const command = process.argv[2];
if (!['migrate','seed','check'].includes(command)) throw new Error('Use migrate, seed, or check.');
const pool = getPool();
try {
  if (command === 'check') {
    await pool.query('SELECT 1');
    console.log('Database connection OK.');
  } else {
    await pool.query(await readFile(new URL(command === 'migrate' ? '../src/db/schema.sql' : '../src/db/seed.sql', import.meta.url), 'utf8'));
    console.log(command === 'migrate' ? 'Schema ready.' : 'Demo volunteers and opportunities seeded.');
  }
} catch {
  console.error('Database operation failed. Check configuration, TLS certificate, and database permissions. No credentials are printed.');
  process.exitCode = 1;
} finally { await pool.end(); }
