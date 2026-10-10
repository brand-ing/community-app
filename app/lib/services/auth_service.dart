import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config.dart';

/// One place for login/logout. Web and phones use different Auth0 classes,
/// so this hides that difference from the rest of the app.
///
/// Passkeys / Face ID need no code here: turn them on in the Auth0 dashboard
/// and they appear on the Auth0 login page automatically.
class AuthService {
  final Auth0 _mobile = Auth0(Config.auth0Domain, Config.auth0ClientId);
  final Auth0Web _web = Auth0Web(Config.auth0Domain, Config.auth0ClientId);

  Credentials? _credentials;

  bool get isLoggedIn => _credentials != null;
  String? get accessToken => _credentials?.accessToken;
  UserProfile? get user => _credentials?.user;

  /// On web, finishes a login after Auth0 redirects back to the app.
  Future<void> init() async {
    if (kIsWeb) {
      _credentials = await _web.onLoad(audience: Config.apiAudience);
    }
  }

  Future<void> login() async {
    if (kIsWeb) {
      // Leaves the page; init() picks up the result when it comes back.
      await _web.loginWithRedirect(
        redirectUrl: Uri.base.origin,
        audience: Config.apiAudience,
      );
    } else {
      _credentials = await _mobile
          .webAuthentication(scheme: Config.appScheme)
          .login(audience: Config.apiAudience);
    }
  }

  Future<void> logout() async {
    if (kIsWeb) {
      await _web.logout(returnToUrl: Uri.base.origin);
    } else {
      await _mobile.webAuthentication(scheme: Config.appScheme).logout();
    }
    _credentials = null;
  }
}
