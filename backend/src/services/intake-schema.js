import { z } from 'zod';
export const categories = ['gardening','food','companionship','tutoring','pet_care','errands','technology','other','unknown'];
const fields = ['title','description','category','location','timing','supportMode','skillsNeeded'];
export const draftSchema = z.object({
  title: z.string().trim().min(1).max(120).nullable(),
  description: z.string().trim().min(1).max(1500).nullable(),
  category: z.enum(categories), location: z.string().trim().min(1).max(160).nullable(),
  timing: z.string().trim().min(1).max(250).nullable(),
  supportMode: z.enum(['in_person','remote','either','unknown']),
  skillsNeeded: z.array(z.string().trim().min(1).max(80)).max(8),
  evidence: z.array(z.object({ field: z.enum(fields), quote: z.string().min(1).max(2000) }).strict()).max(20),
}).strict();
export const outputSchema = z.object({ assistantMessage: z.string().trim().min(1).max(1500), draft: draftSchema }).strict();
export const turnSchema = z.object({ conversationId: z.uuid(), turnId: z.uuid(), message: z.string().trim().min(1).max(2000) }).strict();
export function validateEvidence(draft, history) {
  const userMessages = history.filter((turn) => turn.role === 'user').map((turn) => turn.text);
  if (draft.evidence.some((item) => !userMessages.some((text) => text.includes(item.quote)))) throw new Error('Evidence is not present in user messages.');
  for (const field of fields) {
    const value = draft[field];
    const populated = Array.isArray(value) ? value.length > 0 : value !== null && value !== 'unknown';
    if (populated && !draft.evidence.some((item) => item.field === field)) throw new Error(`Missing evidence for ${field}.`);
  }
  return draft;
}
export function missingFields(draft) {
  const missing = ['title','description','timing'].filter((field) => !draft[field]);
  if (draft.category === 'unknown') missing.push('category');
  if (draft.supportMode === 'unknown') missing.push('supportMode');
  if (draft.supportMode !== 'remote' && !draft.location) missing.push('location');
  return missing;
}
