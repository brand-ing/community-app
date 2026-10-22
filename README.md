# Angel’s Nest — Making Living Easier

## Judges: run the demo on your computer

Angel’s Nest is a responsive community app built with Flutter for web, Android, and iOS. The submitted presentation uses **local mock data and a scripted Angel chat**. You can explore it without Auth0 credentials, a Gemini key, Tiger Data, or a running backend. Nothing is sent to volunteers or saved to a cloud database.

### Requirements

- Git: https://git-scm.com/downloads
- Flutter SDK on your PATH: https://docs.flutter.dev/get-started/install
- Google Chrome for the desktop browser demo.

On Windows, put the checkout somewhere outside OneDrive (for example `C:\Projects\community-app`). Run `flutter doctor` after installing Flutter to check your setup. Android/iOS build tools are not required for this web demo; warnings about those platforms do not prevent a Chrome run.

### Clone, install, and launch

Open PowerShell, Terminal, or your editor's terminal:

```sh
git clone https://github.com/brand-ing/community-app.git
cd community-app/app
flutter config --enable-web
flutter pub get
flutter run -d chrome --web-port 3000
```

**Do not add `--dart-define-from-file=config.json` for the judges' demo.** That private local file is not included in GitHub and is not required. The command above launches the app without external login configuration.

Flutter opens Chrome. If it does not, visit **http://localhost:3000**. Keep the terminal running while you explore. Stop the app with Ctrl+C. If port 3000 is already used, choose another port, such as `--web-port 3001`, and use that address.

### What to click

1. On the product page choose **Continue to the app**.
2. You enter the app directly as **neighbor**. Sign-in is optional through the account button; no account is required.
3. **I want to volunteer:** browse fictional community offerings and the category menu; open a listing's details.
4. **I need help:** open Chat with Angel. Type `Help with my garden`, then `Saturday morning`, then `Midtown Atlanta`. Expand **Review your request** and choose **Confirm demo request**. Replies are scripted to demonstrate intake; this is not live Gemini inference. The demo keeps your entered details in memory and resets on reload.
5. **Service Exchange:** explore creating an offer with an expiration, proposing a trade, comparing offerings, and accepting or declining within the mockup.
6. **Community:** browse posts, read an article, and explore the local posting experience.
7. Use the theme button to switch light/dark mode and resize the browser to preview mobile and desktop layouts.

### Build a deployable web version

From the `app` directory:

```sh
flutter build web
```

The output is **`app/build/web`** when viewed from the repository root. Upload the contents of that folder to a static host. To preview the output locally, if Python is installed:

```sh
python -m http.server 3000 --directory build/web
```

Open http://localhost:3000. Do not open `index.html` directly as a file; serve it over HTTP. Web build output and secrets are excluded from Git; judges build them using the commands above.

### Validation and implementation status

From `app`, run `flutter test` and `flutter analyze`. At submission preparation, 23 Flutter tests passed and analysis reported no issues. A production web build also succeeded.

The default app uses `DemoApiService`, with six fictional opportunities and a guided chat/review flow. Community and Service Exchange are local prototypes. Real matching, contacting volunteers, persistent community posts, and production data management are future work.

The repo also contains an initial authenticated Node/Express backend with Gemini structured-output prompts, Postgres schema and demo seeds. It is **not required for the submitted demo**, and the cloud integration is not live-verified. Backend secrets remain outside Git. See [backend setup and prompt guide](docs/backend-gemini-tigerdata.md) and [demo walkthrough](docs/demo-submission.md). The existing Auth0/backend instructions below are for future integration development; they are optional and are not the judges' setup path.

---

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
