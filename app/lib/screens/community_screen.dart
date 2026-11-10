import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key, this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          actions: const [ThemeToggleButton()],
        ),
        body: const Center(
            child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Community posts are not available yet.',
              textAlign: TextAlign.center),
        )),
      );
}
