import 'package:flutter/material.dart';

import 'config.dart';
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
        title: 'AngelNest',
        debugShowCheckedModeBanner: false,
        theme: _angelTheme(Brightness.light),
        darkTheme: _angelTheme(Brightness.dark),
        themeMode: _mode,
        home: const AuthGate(),
      ),
    );
  }
}

ThemeData _angelTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFAD7045),
    brightness: brightness,
  ).copyWith(
    primary: isLight ? const Color(0xFF87502D) : const Color(0xFFF3BC91),
    primaryContainer:
        isLight ? const Color(0xFFFFE8D5) : const Color(0xFF59381F),
    secondary: isLight ? const Color(0xFF796020) : const Color(0xFFE6CB84),
    secondaryContainer:
        isLight ? const Color(0xFFF8EDCA) : const Color(0xFF51421D),
    tertiary: isLight ? const Color(0xFF935E57) : const Color(0xFFF0BDB4),
    tertiaryContainer:
        isLight ? const Color(0xFFFBE5DF) : const Color(0xFF573B36),
    surface: isLight ? const Color(0xFFFFFCF7) : const Color(0xFF211B17),
    onSurface: isLight ? const Color(0xFF3D3028) : const Color(0xFFF3E7DD),
    onSurfaceVariant:
        isLight ? const Color(0xFF716158) : const Color(0xFFD2C0B4),
    outlineVariant: isLight ? const Color(0xFFEADDD0) : const Color(0xFF51443B),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        isLight ? const Color(0xFFFBF5EB) : const Color(0xFF191511),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    )),
  );
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
              'Sign-in is not configured yet. Please ask the AngelNest team to enable it.');
          return;
        }
        _run(_auth.login);
      },
      error: _error,
    );
  }
}
