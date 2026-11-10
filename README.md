# Angel's Nest — Making Living Easier

Angel's Nest is a Flutter app for volunteering, requesting help, and exchanging services. See [TODO.md](TODO.md) for active work, next steps, and acceptance checks.

## Run the app locally

Install Git, the [Flutter SDK](https://docs.flutter.dev/get-started/install), and Chrome. On Windows, clone outside OneDrive.

```sh
git clone https://github.com/brand-ing/community-app.git
cd community-app/app
flutter pub get
flutter run -d chrome --web-port 3000
```

Open http://localhost:3000 and choose **Continue to the app**. Guests can explore the app shell with no keys, config file, or backend.

Guest Angel chat, Service Exchange, and Community show their current availability. With optional Auth0 sign-in and a configured backend, the existing inline help intake and database-backed volunteer listings are accessible. Those cloud paths have not been live-verified. Gemini journey routing is in progress.

From the app directory, use `flutter test`, `flutter analyze`, or `flutter build web`. The web build goes to `app/build/web` relative to the repository root. Building locally does not deploy the website. See the [Netlify deployment guide](docs/deploy-netlify.md) for manual upload and GitHub Actions.

See the [backend setup guide](docs/backend-gemini-tigerdata.md) for credentials, schemas, and prompts.

## Optional: authenticated backend development

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
