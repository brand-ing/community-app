# AGENTS.md

Instructions for AI coding tools (Codex, Claude Code, etc.) working in this repo.

## What this project is
Hackathon app. Flutter frontend (web + iOS + Android) with Auth0 login, and a Node/Express backend.
Planned: Gemini API (backend), Tiger Data / Postgres database (backend), hosted on Vultr.

## Layout
- `app/lib/main.dart` — app entry + `AuthGate` (decides login vs. home)
- `app/lib/screens/` — one file per screen
- `app/lib/services/auth_service.dart` — all login/logout logic (web and mobile)
- `app/lib/services/api_service.dart` — all HTTP calls to the backend; add new endpoints here
- `app/lib/config.dart` — settings from `--dart-define-from-file=config.json`
- `backend/src/index.js` — server setup, auth middleware
- `backend/src/routes/` — one file per route group; everything under `/api` requires login

## Commands
- Backend: `cd backend && npm run dev`
- App: `cd app && flutter run -d chrome --web-port 3000 --dart-define-from-file=config.json`
- Format Dart: `cd app && dart format lib`
- Analyze Dart: `cd app && flutter analyze`

## Rules
- **Never hardcode keys or secrets.** Backend secrets go in `backend/.env` (read via `process.env`). Never add API keys to the Flutter app — call the backend instead.
- Never edit `.env`, `config.json`, or `.gitignore` entries that protect them.
- The Flutter app never calls Gemini or the database directly. Flow is always: app → `ApiService` → backend route → external service.
- Identify users by the Auth0 `sub` claim (`req.auth.payload.sub`), never by email.
- Keep changes scoped to the issue you were given. Don't refactor or restyle files outside it.
- New screen = new file in `app/lib/screens/`. New backend route = new file in `backend/src/routes/`, mounted in `index.js`.
- UI design isn't decided yet: use Material 3 defaults and `Theme.of(context)` colors, no hardcoded colors.
