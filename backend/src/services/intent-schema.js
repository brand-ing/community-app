import { z } from 'zod';

export const intentOutputSchema = z.object({
  intent: z.enum(['volunteer', 'help', 'exchange', 'unclear']),
  assistantMessage: z.string().trim().min(1).max(1500), // Existing intake schema is 1500 this may change
}).strict();