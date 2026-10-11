import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

const _opportunities = [
  (
    title: 'Lend a hand at a community garden',
    host: 'Neighborhood garden team',
    category: 'Volunteer',
    time: 'Weekend mornings',
    location: 'In person',
    description:
        'Help plant, water, and care for a shared green space. No gardening experience needed.',
    icon: Icons.local_florist_outlined
  ),
  (
    title: 'Pack meals for neighbors',
    host: 'Community pantry',
    category: 'Volunteer',
    time: '2-hour shifts',
    location: 'In person',
    description:
        'Sort donations and prepare food packages alongside other volunteers.',
    icon: Icons.restaurant_outlined
  ),
  (
    title: 'Be a friendly check-in buddy',
    host: 'Neighbor connection group',
    category: 'Volunteer',
    time: 'Flexible schedule',
    location: 'Remote',
    description:
        'Make time for a friendly conversation with someone who could use company.',
    icon: Icons.forum_outlined
  ),
  (
    title: 'Help with a small yard project',
    host: 'Community member',
    category: 'Odd jobs',
    time: 'One-time task',
    location: 'In person',
    description:
        'Offer a helping hand with light yard work. Scope and payment would be agreed with the requester.',
    icon: Icons.handyman_outlined
  ),
  (
    title: 'Share your knowledge with a learner',
    host: 'Community member',
    category: 'Tutoring',
    time: 'Flexible schedule',
    location: 'Remote or in person',
    description:
        'Help someone practice a subject you know. Session details and payment would be agreed together.',
    icon: Icons.school_outlined
  ),
  (
    title: 'Take a neighbor\'s dog for a walk',
    host: 'Community member',
    category: 'Pet care',
    time: 'Short visits',
    location: 'In person',
    description:
        'Offer local dog walks or pet check-ins. Responsibilities and payment would be agreed with the owner.',
    icon: Icons.pets_outlined
  ),
];

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key, this.initialCategory = 'Volunteer'});
  final String initialCategory;

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  late String _category;
  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  void _showDetails(int index) {
    final opportunity = _opportunities[index];
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(opportunity.title),
              content: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${opportunity.host}\n${opportunity.time} · ${opportunity.location}'),
                  const SizedBox(height: 20),
                  Text(opportunity.description),
                  const SizedBox(height: 20),
                  const Text(
                      'Example listing. Contact and sign-up will be available when live community listings are connected.'),
                ],
              )),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to listings'))
              ],
            ));
  }

  Widget _menu(BuildContext context, bool wide) {
    final theme = Theme.of(context);
    final options = [
      (
        label: 'Volunteer opportunities',
        value: 'Volunteer',
        icon: Icons.volunteer_activism_outlined
      ),
      (label: 'Odd jobs', value: 'Odd jobs', icon: Icons.handyman_outlined),
      (label: 'Tutoring', value: 'Tutoring', icon: Icons.school_outlined),
      (label: 'Pet care', value: 'Pet care', icon: Icons.pets_outlined),
    ];
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant)),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore your community',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              if (wide) ...[
                for (var i = 0; i < options.length; i++) ...[
                  if (i == 1)
                    Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Text('Quick money options',
                            style: theme.textTheme.titleSmall)),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    selected: _category == options[i].value,
                    selectedTileColor: theme.colorScheme.primaryContainer,
                    leading: Icon(options[i].icon),
                    title: Text(options[i].label),
                    onTap: () => setState(() => _category = options[i].value),
                  ),
                ],
              ] else ...[
                ChoiceChip(
                  label: const Text('Volunteer opportunities'),
                  selected: _category == 'Volunteer',
                  onSelected: (_) => setState(() => _category = 'Volunteer'),
                ),
                const SizedBox(height: 20),
                Text('Quick money options', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final option in options.skip(1))
                    ChoiceChip(
                      avatar: Icon(option.icon, size: 18),
                      label: Text(option.label),
                      selected: _category == option.value,
                      onSelected: (_) =>
                          setState(() => _category = option.value),
                    ),
                ]),
              ],
              const SizedBox(height: 20),
              Text(
                  'Volunteering gives time freely. Quick money options are paid community tasks.',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant, height: 1.5)),
            ],
          )),
    );
  }

  Widget _listings(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          _category == 'Volunteer'
              ? 'Volunteer offerings'
              : '$_category opportunities',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      Text(
          _category == 'Volunteer'
              ? 'Give your time to something that matters to you.'
              : 'Explore ways to earn by sharing your time and skills.',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: colors.onSurfaceVariant)),
      const SizedBox(height: 20),
      for (var i = 0; i < _opportunities.length; i++)
        if (_opportunities[i].category == _category)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.outlineVariant)),
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(
                              backgroundColor: colors.primaryContainer,
                              foregroundColor: colors.primary,
                              child: Icon(_opportunities[i].icon)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(_opportunities[i].host,
                                  style: theme.textTheme.labelLarge)),
                        ]),
                        const SizedBox(height: 20),
                        Text(_opportunities[i].title,
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(_opportunities[i].description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant, height: 1.5)),
                        const SizedBox(height: 16),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          Chip(
                              label: Text(_category == 'Volunteer'
                                  ? 'Unpaid volunteer role'
                                  : 'Paid task · rate to be agreed')),
                          Chip(label: Text(_opportunities[i].time)),
                          Chip(label: Text(_opportunities[i].location)),
                        ]),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                            onPressed: () => _showDetails(i),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('View details')),
                      ])),
            ),
          ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('I want to volunteer'),
          actions: const [ThemeToggleButton()]),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Quick Opportunities',
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text(
                  'Short-term tasks, ways to support your community, and opportunities to earn.',
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16)),
                child: const Text(
                    'Preview listings · These examples show the experience. Live volunteer offerings and paid tasks are not connected yet.'),
              ),
              const SizedBox(height: 28),
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth >= 850;
                if (wide) {
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 280, child: _menu(context, true)),
                        const SizedBox(width: 28),
                        Expanded(child: _listings(context)),
                      ]);
                }
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _menu(context, false),
                      const SizedBox(height: 28),
                      _listings(context),
                    ]);
              }),
            ])),
      )))),
    );
  }
}
