import { Router } from 'express';
import { rateLimit } from 'express-rate-limit';
import { z } from 'zod';
import { turnSchema } from '../services/intake-schema.js';
export function createAngelRouter(service) {
  const router = Router();
  router.use(rateLimit({ windowMs: 60000, limit: 10, keyGenerator: (req) => req.auth.payload.sub,
    standardHeaders: 'draft-8', legacyHeaders: false, message: { message: 'Please wait a moment before sending more messages.' } }));
  router.post('/chat', async (req,res,next) => {
    const parsed = turnSchema.safeParse(req.body);
    if (!parsed.success) return res.status(400).json({ message:'Send a message of 1–2000 characters and valid conversation and turn IDs.' });
    try { res.json(await service.chat(req.auth.payload.sub, parsed.data)); } catch(error) { next(error); }
  });
  router.post('/:id/confirm', async (req,res,next) => {
    const parsed = z.object({ revision:z.number().int().positive() }).strict().safeParse(req.body);
    if (!z.uuid().safeParse(req.params.id).success || !parsed.success) return res.status(400).json({ message:'A valid conversation ID and draft revision are required.' });
    try { res.json({ request:await service.confirm(req.auth.payload.sub,req.params.id,parsed.data.revision) }); } catch(error) { next(error); }
  });
  return router;
}
