import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { auth } from 'express-oauth2-jwt-bearer';
import meRouter from './routes/me.js';

// Fail fast with a clear message if .env is missing values.
const required = ['AUTH0_DOMAIN', 'AUTH0_AUDIENCE'];
const missing = required.filter((key) => !process.env[key]);
if (missing.length) {
  console.error(`Missing ${missing.join(', ')} — copy backend/.env.example to backend/.env and fill it in.`);
  process.exit(1);
}

const app = express();
app.use(express.json());
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
app.use('/api', requireLogin);
app.use('/api/me', meRouter);

// Turn auth failures into clean JSON instead of HTML stack traces
app.use((err, _req, res, _next) => {
  const status = err.status || 500;
  const code = err.code || (status === 401 ? 'unauthorized' : 'server_error');
  res.status(status).json({ error: code, message: err.message });
});

const port = Number(process.env.PORT) || 8080;
app.listen(port, () => console.log(`Backend running on http://localhost:${port}`));
