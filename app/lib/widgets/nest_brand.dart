import 'package:flutter/material.dart';
import '../theme/angel_theme.dart';

class NestWordmark extends StatelessWidget {
  const NestWordmark({super.key, this.large = false});
  final bool large;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
        TextSpan(children: [
          const TextSpan(text: 'Angel’s '),
          TextSpan(
              text: 'Nest',
              style: TextStyle(color: NestPalette.of(context).accents[0]))
        ]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            (large ? theme.textTheme.displaySmall : theme.textTheme.titleLarge)
                ?.copyWith(letterSpacing: -1));
  }
}

class NestQuote extends StatelessWidget {
  const NestQuote({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: NestPalette.of(context).quote,
            borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.format_quote_rounded,
              color: NestPalette.of(context).accents[1], size: 28),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('You are capable, brave, and more loved than you realize.',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 10),
                Text('— UNKNOWN',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.5))
              ]))
        ]));
  }
}
