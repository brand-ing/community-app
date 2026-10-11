import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { auth } from 'express-oauth2-jwt-bearer';
import meRouter from './routes/me.js';
import { getPool } from './db/pool.js';
import { generateIntake } from './services/gemini.js';
import { createAngelService } from './services/angel.js';
import { createAngelRouter } from './routes/angel.js';
import { createVolunteersRouter, createOpportunitiesRouter } from './routes/volunteers.js';

// Fail fast with a clear message if .env is missing values.
const required = ['AUTH0_DOMAIN', 'AUTH0_AUDIENCE'];
const missing = required.filter((key) => !process.env[key]);
if (missing.length) {
  console.error(`Missing ${missing.join(', ')} — copy backend/.env.example to backend/.env and fill it in.`);
  process.exit(1);
}

const app = express();
app.use(express.json({ limit: '16kb' }));
app.use(
  cors({
    origin: (process.env.CORS_ORIGINS || 'http://localhost:3000').split(',').map((s) => s.trim()),
  }),
);

// Checks the Auth0 access token on every request it's applied to.
const requireLogin = auth({
  issuerBaseURL: `https://${process.env.AUTH0_DOMAIN}/`,
  audience: process.env.AUTH0_AUDIENCE,
});

// Public
app.get('/health', (_req, res) => res.json({ ok: true }));

// Protected: everything under /api needs a logged-in user
app.use('/api', requireLogin, (req,res,next) => {
  if (typeof req.auth?.payload?.sub !== 'string' || !req.auth.payload.sub) return res.status(401).json({message:'Sign in to continue.'});
  next();
});
app.use('/api/me', meRouter);
app.use('/api/angel', createAngelRouter(createAngelService({ getPool, generate:generateIntake })));
app.use('/api/volunteers', createVolunteersRouter(getPool));
app.use('/api/opportunities', createOpportunitiesRouter(getPool));

// Turn auth failures into clean JSON instead of HTML stack traces
app.use((err, _req, res, _next) => {
  const status = err.status || 500;
  const code = err.code || (status === 401 ? 'unauthorized' : 'server_error');
  res.status(status).json({ error: code, message: status >= 500 && status !== 502 && status !== 503 ? 'Backend operation failed. Please try again.' : err.message });
});

const port = Number(process.env.PORT) || 8080;
app.listen(port, () => console.log(`Backend running on http://localhost:${port}`));
