import 'package:flutter/material.dart';
import 'service_choices.dart';
import '../widgets/theme_toggle_button.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(title: const Text('AngelNest'), actions: [
          const ThemeToggleButton(),
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                  onPressed: onContinue,
                  child: Text(constraints.maxWidth < 400
                      ? 'Continue'
                      : 'Continue to the app'))),
        ]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                      avatar: Icon(Icons.favorite_outline,
                          color: theme.colorScheme.primary),
                      label: const Text('Small acts. Stronger communities.')),
                  const SizedBox(height: 28),
                  Text('A place to help.\nA place to belong.',
                      style: theme.textTheme.displayMedium),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        'AngelNest brings people back into community. Volunteer your time, ask for a helping hand, or exchange skills with people around you.',
                        style: theme.textTheme.titleLarge,
                      )),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                      onPressed: onContinue,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Find your place in the community')),
                  const SizedBox(height: 12),
                  const Text('Sign in or create an account to get started.'),
                  const SizedBox(height: 64),
                  Text('Three ways to connect',
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  const Text(
                      'Start with what you can give, what you need, or what you can share.'),
                  const SizedBox(height: 24),
                  const ServiceChoices(),
                  const SizedBox(height: 48),
                  Card.filled(
                      child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Community starts with a conversation.',
                                  style: theme.textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              const Text(
                                  'Our first version starts with three simple paths. Together, we can shape what comes next.'),
                              const SizedBox(height: 20),
                              OutlinedButton(
                                  onPressed: onContinue,
                                  child: const Text('Continue to AngelNest')),
                            ],
                          ))),
                  const SizedBox(height: 32),
                  const Text('AngelNest · People helping people.'),
                ],
              )),
        )))),
      );
    });
  }
}
