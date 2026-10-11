import pg from 'pg';
import { readFileSync } from 'node:fs';
let pool;
export function getPool() {
  if (!process.env.DATABASE_URL) throw Object.assign(new Error('Database is not configured. Set DATABASE_URL on the backend.'), { status: 503 });
  if (!pool) {
    const url = new URL(process.env.DATABASE_URL);
    // Do not allow URL options to overwrite certificate verification.
    for (const key of ['sslmode','sslcert','sslkey','sslrootcert']) url.searchParams.delete(key);
    if (process.env.DATABASE_SSL === 'false' && !['localhost','127.0.0.1','[::1]'].includes(url.hostname)) throw new Error('SSL may only be disabled for a local database.');
    const ssl = process.env.DATABASE_SSL === 'false' ? false : {
      rejectUnauthorized: true,
      ...(process.env.DATABASE_CA_FILE ? { ca: readFileSync(process.env.DATABASE_CA_FILE, 'utf8') } : {}),
    };
    pool = new pg.Pool({ connectionString: url.toString(), ssl, max: 5, connectionTimeoutMillis: 10000, statement_timeout: 10000 });
    pool.on('error', () => console.error('Database pool connection error.'));
  }
  return pool;
}
