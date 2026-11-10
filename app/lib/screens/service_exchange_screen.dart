import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class ServiceExchangeScreen extends StatelessWidget {
  const ServiceExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Service Exchange'),
          actions: const [ThemeToggleButton()],
        ),
        body: const Center(
            child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Service exchanges are not available yet.',
              textAlign: TextAlign.center),
        )),
      );
}
