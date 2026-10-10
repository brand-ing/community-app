import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

/// Skeleton signed-in screen. The "Test backend" button proves the
/// Flutter app → Auth0 → backend chain works end to end.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user, required this.api, required this.onLogout});

  final UserProfile? user;
  final ApiService api;
  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _result;
  bool _calling = false;

  Future<void> _testBackend() async {
    setState(() => _calling = true);
    try {
      final data = await widget.api.getMe();
      _result = '${data['message']}\nuserId: ${data['userId']}';
    } catch (e) {
      _result = 'Backend call failed: $e';
    }
    if (mounted) setState(() => _calling = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Log out', onPressed: widget.onLogout),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: user?.pictureUrl != null ? NetworkImage(user!.pictureUrl.toString()) : null,
              child: user?.pictureUrl == null ? const Icon(Icons.person) : null,
            ),
            title: Text(user?.name ?? 'Signed in'),
            subtitle: Text(user?.email ?? ''),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _calling ? null : _testBackend,
            icon: const Icon(Icons.cloud_done_outlined),
            label: Text(_calling ? 'Calling…' : 'Test backend'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            SelectableText(_result!),
          ],
          const SizedBox(height: 32),
          const Text('TODO: real features go here (see GitHub issues).'),
        ],
      ),
    );
  }
}
