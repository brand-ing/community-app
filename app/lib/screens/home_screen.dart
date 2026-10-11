import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'service_choices.dart';
import '../utils/display_name.dart';
import '../widgets/theme_toggle_button.dart';
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

  void _showProfile(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Your profile'),
              content: Text(
                  '${firstName(user?.name, fallback: 'Community member')}\n${user?.email ?? ''}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('AngelNest'), actions: [
        const ThemeToggleButton(),
        IconButton(
            onPressed: () => _showProfile(context),
            tooltip: 'Your profile',
            icon: const Icon(Icons.account_circle_outlined)),
        IconButton(
            onPressed: onLogout,
            tooltip: 'Log out',
            icon: const Icon(Icons.logout)),
        const SizedBox(width: 8),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.surface
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.wb_sunny_outlined,
                              color: theme.colorScheme.primary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text('Welcome, ${firstName(user?.name)}.',
                                  style: theme.textTheme.titleMedium)),
                        ]),
                        const SizedBox(height: 20),
                        Text('A little kindness.\nA stronger community.',
                            style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w600, height: 1.2)),
                        const SizedBox(height: 16),
                        Text(
                            'Your time, your talents, your helping hand. There is a place for you here.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.6)),
                      ]),
                ),
                const SizedBox(height: 36),
                Text('How would you like to connect?',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text('Choose the path that feels right for you today.',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),
                ServiceChoices(onSelect: (index) {
                  if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => const VolunteerScreen()));
                    return;
                  }
                  if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => AngelChatScreen(userName: user?.name)));
                    return;
                  }
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(communityServices[index].title),
                            content: const Text(
                                'This is the start of your journey. Community listings and requests are coming in a future version of AngelNest.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Back to community'))
                            ],
                          ));
                }),
              ],
            )),
      )))),
    );
  }
}
