import { readFileSync } from 'node:fs';
import { GoogleGenAI } from '@google/genai';
import { z } from 'zod';
import { outputSchema, validateEvidence } from './intake-schema.js';
const instruction = readFileSync(new URL('../prompts/angel-intake.md', import.meta.url), 'utf8');
export async function generateIntake(history) {
  if (!process.env.GEMINI_API_KEY || !process.env.GEMINI_MODEL) throw Object.assign(new Error('Angel is not configured. Set GEMINI_API_KEY and GEMINI_MODEL on the backend.'), { status: 503 });
  try {
    const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
    const result = await ai.interactions.create({
      model: process.env.GEMINI_MODEL, store: false,
      system_instruction: instruction,
      input: JSON.stringify({ transcript: history }),
      response_format: { type: 'text', mime_type: 'application/json', schema: z.toJSONSchema(outputSchema) },
    }, { timeout: 45000 });
    const parsed = outputSchema.parse(JSON.parse(result.output_text));
    validateEvidence(parsed.draft, history);
    return parsed;
  } catch (error) {
    if (error.status === 429) throw Object.assign(new Error('Angel is busy. Please try again shortly.'), { status: 429 });
    throw Object.assign(new Error('Angel could not produce a reliable response. Please retry; your request has not been confirmed.'), { status: 502 });
  }
}
