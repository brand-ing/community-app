import test from 'node:test';
import assert from 'node:assert/strict';
import { intentOutputSchema } from '../src/services/intent-schema.js';

test('accepts each supported intent', () => {
  for (const intent of ['volunteer', 'help', 'exchange', 'unclear']) {
    const result = intentOutputSchema.safeParse({
      intent,
      assistantMessage: 'Tell me a little more.',
    });

    assert.equal(result.success, true, `Should accept ${intent}`);
  }
});

test('rejects unsupported intents', () => {
  // Your code here
  const result = intentOutputSchema.safeParse({
    intent: 'donate',
    assistantMessage: 'Tell me a little more.',
  });
  assert.equal(result.success, false, 'Should reject unsupported intent');
});

test('rejects empty assistantMessage', () => {
  const result = intentOutputSchema.safeParse({
    intent: 'help',
    assistantMessage: ' ',
  });
  assert.equal(result.success, false, 'Should reject empty assistantMessage');
});

test('rejects output missing assistantMessage', () => {
  const result = intentOutputSchema.safeParse({
    intent: 'help',
    // Missing assistantMessage
  });
  assert.equal(result.success, false, 'Should reject missing required fields');
});


test('rejects output missing intent', () => {
  const result = intentOutputSchema.safeParse({
    // Missing intent
    assistantMessage: 'How can I help you?',
  });
  assert.equal(result.success, false, 'Should reject missing required fields');
});

test('rejects non-string assistantMessage',() => {
  const result = intentOutputSchema.safeParse({
    intent: 'help',
    assistantMessage: 12345, // Non-string value
  });
  assert.equal(result.success, false, 'Should reject non-string assistantMessage');
});

// Remaining tests:
// rejects unexpected properties
//accepts an assistant message at the length limit
//rejects assistant messages above the length limit
//trims surrounding whitespace from assistant messages
