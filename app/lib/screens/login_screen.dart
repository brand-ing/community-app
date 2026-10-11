import 'package:flutter/material.dart';
import '../theme/angel_theme.dart';
import '../widgets/nest_brand.dart';
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
    final palette = NestPalette.of(context);
    return Scaffold(
        appBar: AppBar(
            actions: const [ThemeToggleButton()],
            leading: IconButton(
                onPressed: onBack,
                tooltip: 'Back to Angel’s Nest',
                icon: const Icon(Icons.arrow_back)),
            title: const NestWordmark()),
        body: Center(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(child: NestWordmark(large: true)),
                              const SizedBox(height: 12),
                              Text('Making Living Easier',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                      letterSpacing: 1.5,
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                              const SizedBox(height: 32),
                              Card(
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          color: theme
                                              .colorScheme.outlineVariant)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Center(
                                                child: CircleAvatar(
                                                    radius: 32,
                                                    backgroundColor:
                                                        palette.tints[0],
                                                    child: Icon(
                                                        Icons
                                                            .favorite_border_rounded,
                                                        color:
                                                            palette.accents[0],
                                                        size: 32))),
                                            const SizedBox(height: 24),
                                            Text('Welcome to your community',
                                                textAlign: TextAlign.center,
                                                style: theme
                                                    .textTheme.headlineMedium),
                                            const SizedBox(height: 16),
                                            Text(
                                                'Sign in or create an account to find your next way to connect.',
                                                textAlign: TextAlign.center,
                                                style: theme.textTheme.bodyLarge
                                                    ?.copyWith(
                                                        color: theme.colorScheme
                                                            .onSurfaceVariant)),
                                            const SizedBox(height: 28),
                                            FilledButton.icon(
                                                onPressed: onLogin,
                                                icon: const Icon(Icons.login),
                                                label: const Text(
                                                    'Sign in / Register')),
                                            const SizedBox(height: 16),
                                            Text(
                                                'Continue to our secure sign-in page. Available sign-in options are shown there.',
                                                textAlign: TextAlign.center,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: theme.colorScheme
                                                            .onSurfaceVariant)),
                                            if (error != null) ...[
                                              const SizedBox(height: 20),
                                              Text(error!,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: theme
                                                          .colorScheme.error))
                                            ]
                                          ]))),
                              const SizedBox(height: 24),
                              const NestQuote()
                            ]))))));
  }
}
