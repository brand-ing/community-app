BEGIN;
CREATE TABLE IF NOT EXISTS angel_conversations (
  id uuid PRIMARY KEY, owner_sub text NOT NULL,
  history jsonb NOT NULL DEFAULT '[]', draft jsonb,
  revision integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS angel_conversations_owner ON angel_conversations(owner_sub);
CREATE TABLE IF NOT EXISTS angel_turns (
  conversation_id uuid NOT NULL REFERENCES angel_conversations(id), turn_id uuid NOT NULL,
  message text NOT NULL, response jsonb NOT NULL, PRIMARY KEY(conversation_id,turn_id)
);
CREATE TABLE IF NOT EXISTS help_requests (
  id uuid PRIMARY KEY, conversation_id uuid NOT NULL UNIQUE REFERENCES angel_conversations(id), owner_sub text NOT NULL,
  title text NOT NULL, description text NOT NULL, category text NOT NULL,
  location text, timing text NOT NULL, support_mode text NOT NULL CHECK(support_mode IN ('in_person','remote','either')),
  skills_needed text[] NOT NULL DEFAULT '{}', evidence jsonb NOT NULL,
  status text NOT NULL DEFAULT 'open', created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS help_requests_owner ON help_requests(owner_sub);
CREATE TABLE IF NOT EXISTS volunteers (
  id uuid PRIMARY KEY, display_name text NOT NULL, categories text[] NOT NULL,
  skills text[] NOT NULL, support_modes text[] NOT NULL, location text NOT NULL,
  availability text NOT NULL, bio text NOT NULL, is_demo boolean NOT NULL DEFAULT false
);
CREATE TABLE IF NOT EXISTS opportunities (
  id uuid PRIMARY KEY, title text NOT NULL, host text NOT NULL, category text NOT NULL,
  time_label text NOT NULL, location_label text NOT NULL, description text NOT NULL,
  is_demo boolean NOT NULL DEFAULT false, created_at timestamptz NOT NULL DEFAULT now()
);
COMMIT;
