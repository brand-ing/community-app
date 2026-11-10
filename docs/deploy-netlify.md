# Deploy the Flutter site to Netlify

The existing project is **magical-pika-9fac25**. Use its Deploys page to keep the same public URL. These steps publish the Flutter frontend in guest mode. They do not deploy the API, database, or Gemini service. No Auth0 configuration file or backend secrets are needed for this build.

## Manual upload

From the repository's `app` directory:

```powershell
flutter pub get
flutter build web --release
```

1. Sign in to Netlify. In **Projects**, open **magical-pika-9fac25 → Deploys**. Use the upload area on that project's page; the generic Netlify Drop page can create a different project.
2. Drag the **`app/build/web` folder** into the upload area. It should contain `index.html` directly. Uploading starts a deploy, so verify the project name first.
3. Once it shows **Published**, open [the existing public site](https://magical-pika-9fac25.netlify.app/) in a private window. Choose **Continue to the app** and confirm the refreshed guest home is visible.

[Netlify manual deploy instructions](https://docs.netlify.com/deploy/create-deploys/)

## GitHub Actions

The [workflow](../.github/workflows/deploy-netlify.yml) only runs when started manually. It analyzes, tests, and builds the Flutter app, then saves a downloadable `angels-nest-web` artifact.

1. In Netlify, open **Project configuration → General → Project details → Project information**. Copy the **Project ID** for **magical-pika-9fac25**.
2. In Netlify, create a [personal access token](https://docs.netlify.com/api-and-cli-guides/api-guides/get-started-with-api/) for an account with deploy access to the project.
3. In GitHub, open **Settings → Secrets and variables → Actions**. In **Secrets**, add a repository secret called `NETLIFY_AUTH_TOKEN`. In **Variables**, add a repository variable called `NETLIFY_SITE_ID` with the Project ID. Enter the token directly in GitHub; keep it out of chat and source files.
4. In GitHub, open **Actions → Deploy Flutter to Netlify → Run workflow**. Use branch **main**. Choose **build** to check the build without credentials, **preview** for a separate Netlify URL, or **production** to update the public site. Preview and production only run from `main`.
5. Check the workflow run. Download the build artifact if you need a manual upload, or open the URL printed by the deploy step. Verify the guest home before publishing a previewed build to production.

[GitHub manual workflow instructions](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow)
