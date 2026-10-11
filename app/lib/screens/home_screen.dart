import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'service_exchange_screen.dart';
import 'community_screen.dart';
import '../utils/display_name.dart';
import '../widgets/nest_brand.dart';
import '../widgets/theme_toggle_button.dart';
import 'service_choices.dart';
import 'angel_chat_screen.dart';
import 'volunteer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key,
      required this.user,
      required this.api,
      required this.onLogout});
  final UserProfile? user;
  final ApiService api;
  final VoidCallback onLogout;
  void _chat(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => AngelChatScreen(userName: user?.name)));
  void _select(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const VolunteerScreen()));
    } else if (index == 1) {
      _chat(context);
    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const ServiceExchangeScreen()));
    }
  }

  void _profile(BuildContext context) => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text('Your profile'),
              content: Text(
                  '${firstName(user?.name, fallback: 'Community member')}\n${user?.email ?? ''}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'))
              ]));
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(title: const NestWordmark(), actions: [
          const ThemeToggleButton(),
          IconButton(
              onPressed: () => _profile(context),
              tooltip: 'Your profile',
              icon: const Icon(Icons.account_circle_outlined)),
          IconButton(
              onPressed: onLogout,
              tooltip: 'Log out',
              icon: const Icon(Icons.logout))
        ]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1080),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const NestWordmark(large: true),
                                  const SizedBox(height: 8),
                                  Text('Making Living Easier',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                              letterSpacing: 2,
                                              color: theme.colorScheme
                                                  .onSurfaceVariant)),
                                  const SizedBox(height: 24),
                                  const NestQuote(),
                                  const SizedBox(height: 24),
                                  const Divider(),
                                  const SizedBox(height: 20),
                                  Text('Welcome, ${firstName(user?.name)}.',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: theme.colorScheme
                                                  .onSurfaceVariant)),
                                  const SizedBox(height: 8),
                                  Text('What brings you here today?',
                                      style: theme.textTheme.headlineMedium),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Choose the path that feels right for you.\nYou can always explore other options later.',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: theme.colorScheme
                                                  .onSurfaceVariant)),
                                  const SizedBox(height: 24),
                                  ServiceChoices(
                                      onSelect: (index) =>
                                          _select(context, index)),
                                  const SizedBox(height: 14),
                                  CommunityChoice(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                              builder: (_) => CommunityScreen(
                                                  userName: user?.name)))),
                                  const SizedBox(height: 24)
                                ])))))));
  }
}
