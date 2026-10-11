import 'package:flutter/material.dart';
import '../theme/angel_theme.dart';

const communityServices = [
  (
    title: 'I want to volunteer',
    description: 'Explore ways to support your community.',
    icon: Icons.favorite_border_rounded
  ),
  (
    title: 'I need help',
    description: 'Find a helping hand. Talk with Angel about what you need.',
    icon: Icons.search_rounded
  ),
  (
    title: 'Service Exchange',
    description: 'Give a skill and get help from someone in your community.',
    icon: Icons.swap_horiz_rounded
  ),
];

class ServiceChoices extends StatelessWidget {
  const ServiceChoices({super.key, this.onSelect});
  final ValueChanged<int>? onSelect;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 850) {
          return IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Expanded(
                      child: _Choice(
                          index: i,
                          compact: false,
                          onTap: onSelect == null ? null : () => onSelect!(i)))
                ]
              ]));
        }
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                _Choice(
                    index: i,
                    compact: true,
                    onTap: onSelect == null ? null : () => onSelect!(i))
              ]
            ]);
      });
}

class CommunityChoice extends StatelessWidget {
  const CommunityChoice({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Choice(
        index: 3,
        compact: true,
        onTap: onTap,
        item: (
          title: 'Community',
          description:
              'Read stories, share a thought, and connect with your community.',
          icon: Icons.groups_outlined,
        ),
      );
}

class _Choice extends StatelessWidget {
  const _Choice(
      {required this.index, required this.compact, this.onTap, this.item});
  final ({String title, String description, IconData icon})? item;
  final int index;
  final bool compact;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = NestPalette.of(context);
    final item = this.item ?? communityServices[index];
    final icon = Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.accents[index].withAlpha(20)),
        child: Icon(item.icon, color: palette.accents[index], size: 30));
    final words =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(item.title,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20)),
      const SizedBox(height: 6),
      Text(item.description,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant))
    ]);
    return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: palette.tints[index],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: palette.accents[index].withAlpha(75))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.all(compact ? 16 : 24),
                child: compact
                    ? Row(children: [
                        icon,
                        const SizedBox(width: 16),
                        Expanded(child: words),
                        if (onTap != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right,
                              color: palette.accents[index])
                        ]
                      ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            icon,
                            const SizedBox(height: 20),
                            words,
                            if (onTap != null) ...[
                              const SizedBox(height: 24),
                              Icon(Icons.arrow_forward_rounded,
                                  color: palette.accents[index])
                            ]
                          ]))));
  }
}
