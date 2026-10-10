# Starter Repo

Flutter app (web + phones) → Auth0 login → Node backend that verifies the login.
Gemini and Tiger Data plug into the backend later.

```
app/        Flutter app (UI)
backend/    Node + Express API (secrets live here)
AGENTS.md   Instructions for Codex / Claude / other AI tools
```

## 1. One-time Auth0 setup (one person does this, then shares the values)

1. Sign up at auth0.com and create a tenant.
2. **Applications → APIs → Create API.** Name: `Starter API`. Identifier: `https://starter-api`. (This is the `API_AUDIENCE`.)
3. **Applications → Applications → Create Application → Single Page Application.** Then in its Settings:
   - Allowed Callback URLs: `http://localhost:3000, starterapp://YOUR_DOMAIN/android/com.example.starter_app/callback`
   - Allowed Logout URLs: same as above
   - Allowed Web Origins: `http://localhost:3000`
   - Copy the **Domain** and **Client ID**.
4. *(Face ID / passkeys)* **Authentication → Database → Username-Password-Authentication → Authentication Methods → turn on Passkey.** No code changes needed — the option shows up on the login page.

Domain and Client ID are not secret. Future secrets (Gemini key, database URL) go only in `backend/.env`; share them with a self-destructing Bitwarden Send link, never in chat.

## 2. Run the backend

```bash
cd backend
cp .env.example .env      # then fill in AUTH0_DOMAIN and AUTH0_AUDIENCE
npm install
npm run dev
```

Check: http://localhost:8080/health shows `{"ok":true}`.

## 3. Run the Flutter app (web)

First time only, generate the platform folders:

```bash
cd app
flutter create . --project-name starter_app --org com.example
flutter pub get
cp config.example.json config.json   # then fill in Domain + Client ID
```

Run it:

```bash
flutter run -d chrome --web-port 3000 --dart-define-from-file=config.json
```

The port must be **3000** because that's what Auth0 and the backend's CORS setting allow.

**✅ Done when:** you sign in, land on Home, press **Test backend**, and see `Backend verified your login 🎉`.

## 4. Running on a phone (after web works)

- **Android emulator:** in `config.json` set `API_BASE_URL` to `http://10.0.2.2:8080` (the emulator's name for your computer). In `android/app/build.gradle`, inside `defaultConfig`, add:
  ```gradle
  manifestPlaceholders += [auth0Domain: "YOUR_DOMAIN", auth0Scheme: "starterapp"]
  ```
- **iOS simulator (Mac only):** `localhost` works. See the auth0_flutter iOS setup notes for the callback URL.
- Run with `flutter run --dart-define-from-file=config.json` and pick the device.

## Troubleshooting

| Symptom | Fix |
|---|---|
| "Missing Auth0 settings" screen | You forgot `--dart-define-from-file=config.json` |
| Auth0 page says "Callback URL mismatch" | Run on port 3000, check Allowed Callback URLs |
| Test backend → 401 | `AUTH0_AUDIENCE` in backend `.env` must match `API_AUDIENCE` in `config.json` exactly |
| Test backend → "Failed to fetch" | Backend not running, or `CORS_ORIGINS` doesn't include `http://localhost:3000` |
| `flutter pub get` version error | Run `flutter pub upgrade --major-versions` |
