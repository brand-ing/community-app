import 'package:flutter/material.dart';

import 'config.dart';
import 'theme/angel_theme.dart';
import 'widgets/theme_toggle_button.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

void main() => runApp(const StarterApp());

class StarterApp extends StatefulWidget {
  const StarterApp({super.key});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  ThemeMode _mode = ThemeMode.system;

  void _toggleTheme() {
    final isDark = _mode == ThemeMode.dark ||
        (_mode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    setState(() => _mode = isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      mode: _mode,
      onToggle: _toggleTheme,
      child: MaterialApp(
        title: 'Angel’s Nest',
        debugShowCheckedModeBanner: false,
        theme: buildAngelTheme(Brightness.light),
        darkTheme: buildAngelTheme(Brightness.dark),
        themeMode: _mode,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides which screen to show: login, or the app.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final _auth = AuthService();
  late final _api = ApiService(() => _auth.accessToken);
  bool _loading = true;
  bool _enterApp = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (Config.isConfigured) {
      _run(_auth.init);
    } else {
      _loading = false;
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (Config.isConfigured && _auth.isLoggedIn) {
      return HomeScreen(
        user: _auth.user,
        api: _api,
        onLogout: () => _run(_auth.logout),
      );
    }
    if (!_enterApp) {
      return ProductScreen(onContinue: () => setState(() => _enterApp = true));
    }
    return LoginScreen(
      onBack: () => setState(() => _enterApp = false),
      onLogin: () {
        if (!Config.isConfigured) {
          setState(() => _error =
              'Sign-in is not configured yet. Please ask the Angel’s Nest team to enable it.');
          return;
        }
        _run(_auth.login);
      },
      error: _error,
    );
  }
}
