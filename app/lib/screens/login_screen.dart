import 'package:flutter/material.dart';

/// Skeleton login screen. The real sign-in form (email, Google, passkey/Face ID)
/// is Auth0's hosted page — this button just opens it.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onLogin, this.error});

  final VoidCallback onLogin;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.lock_outline, size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('App Name', // TODO: real name + logo
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('One-line pitch goes here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in'),
                ),
                const SizedBox(height: 8),
                Text('Email, Google, or Face ID / passkey',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
                if (error != null) ...[
                  const SizedBox(height: 16),
                  Text(error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
