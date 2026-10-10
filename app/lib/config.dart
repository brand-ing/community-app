/// App settings, injected at run time with:
///   flutter run --dart-define-from-file=config.json
///
/// These values are NOT secrets (anything in a Flutter app can be read by users).
/// Real secrets — Gemini key, database URL — live only in backend/.env.
class Config {
  static const auth0Domain = String.fromEnvironment('AUTH0_DOMAIN');
  static const auth0ClientId = String.fromEnvironment('AUTH0_CLIENT_ID');
  static const apiAudience = String.fromEnvironment('API_AUDIENCE');
  static const apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
  static const appScheme = String.fromEnvironment('APP_SCHEME', defaultValue: 'starterapp');

  static bool get isConfigured => auth0Domain.isNotEmpty && auth0ClientId.isNotEmpty;
}
