import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen(
      {super.key, required this.onLogin, required this.onBack, this.error});
  final VoidCallback onLogin;
  final VoidCallback onBack;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          actions: const [ThemeToggleButton()],
          leading: IconButton(
              onPressed: onBack,
              tooltip: 'Back to AngelNest',
              icon: const Icon(Icons.arrow_back)),
          title: const Text('AngelNest')),
      body: Center(
          child: SingleChildScrollView(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.volunteer_activism_outlined,
                    size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text('Welcome to your community',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                const Text(
                    'Sign in or create an account to find your next way to connect.',
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                FilledButton.icon(
                    onPressed: onLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in / Register')),
                const SizedBox(height: 16),
                const Text(
                    'Continue to our secure sign-in page. Available sign-in options are shown there.',
                    textAlign: TextAlign.center),
                if (error != null) ...[
                  const SizedBox(height: 20),
                  Text(error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
              ],
            )),
      ))),
    );
  }
}
