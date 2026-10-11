import 'package:flutter/material.dart';

const communityServices = [
  (
    title: 'I want to volunteer',
    description:
        'Give a little time. Make a real difference for someone nearby.',
    icon: Icons.volunteer_activism_outlined,
    label: 'GIVE YOUR TIME',
    action: 'Explore volunteering',
  ),
  (
    title: 'I need help',
    description:
        'You do not have to do it all alone. Reach out to your community.',
    icon: Icons.favorite_border_rounded,
    label: 'FIND YOUR SUPPORT',
    action: 'Find a helping hand',
  ),
  (
    title: 'Service Exchange',
    description:
        'Share what you know. Find someone whose skills complement yours.',
    icon: Icons.swap_horiz_rounded,
    label: 'SHARE YOUR SKILLS',
    action: 'Discover exchanges',
  ),
];

class ServiceChoices extends StatelessWidget {
  const ServiceChoices({super.key, this.onSelect});
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 850) {
        return IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < communityServices.length; i++) ...[
              if (i > 0) const SizedBox(width: 20),
              Expanded(
                  child: _ServiceCard(
                      index: i,
                      onTap: onSelect == null ? null : () => onSelect!(i))),
            ],
          ],
        ));
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < communityServices.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _ServiceCard(
              index: i, onTap: onSelect == null ? null : () => onSelect!(i)),
        ],
      ]);
    });
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.index, this.onTap});
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final service = communityServices[index];
    final accents = [colors.primary, colors.tertiary, colors.secondary];
    final containers = [
      colors.primaryContainer,
      colors.tertiaryContainer,
      colors.secondaryContainer
    ];
    final accent = accents[index];
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colors.outlineVariant)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                        color: containers[index],
                        borderRadius: BorderRadius.circular(24)),
                    child: Icon(service.icon, size: 34, color: accent),
                  ),
                  const SizedBox(height: 28),
                  Text(service.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(service.title,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Text(service.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant, height: 1.6)),
                ]),
                if (onTap != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(children: [
                      Expanded(
                          child: Text(service.action,
                              style: theme.textTheme.labelLarge
                                  ?.copyWith(color: accent))),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          size: 20, color: accent),
                    ]),
                  ),
              ],
            )),
      ),
    );
  }
}
