# Angel’s Nest submission demo

This presentation runs with local mock data. Angel replies are scripted, not live Gemini responses. Volunteer offerings are fictional. Confirmed requests stay in memory; no database writes, messages to volunteers, or publishing occur. Reloading resets the demo.

Run from PowerShell:

```powershell
cd C:\Users\epice\Projects\AngelNest\app
flutter run -d chrome --web-port 3000 --dart-define-from-file=config.json
```

On the product page choose Continue to the app, then Explore the demo. Existing signed-in sessions can also use the same mock screens. You do not need to start the backend or configure Tiger Data/Gemini to use the demo.

Presentation path:
1. Open I want to volunteer and browse categories.
2. Open I need help. Type: Help with my garden.
3. Reply: Saturday morning.
4. Reply: Midtown Atlanta.
5. Expand Review your request and select Confirm demo request.
6. Explore the existing Community and Service Exchange mockups.

If Flutter is already running, use a hot restart (capital R in its terminal) and reload the browser to clear the previous failed request. New local mock sessions are created by DemoApiService; the original backend integration remains in the repo for later work.

The web build is generated in app/build/web. Upload that folder to a static website host if the submission requires a hosted site. The local URL is only available on your computer.
