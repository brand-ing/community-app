import 'package:flutter/material.dart';

class AppThemeScope extends InheritedWidget {
  const AppThemeScope(
      {super.key,
      required this.mode,
      required this.onToggle,
      required super.child});
  final ThemeMode mode;
  final VoidCallback onToggle;

  static AppThemeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppThemeScope>();

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) => mode != oldWidget.mode;
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: AppThemeScope.maybeOf(context)?.onToggle,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
