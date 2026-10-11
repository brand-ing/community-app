import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class _TradeReply {
  _TradeReply(this.offerings);
  final List<String> offerings;
  String status = 'Pending';
}

/// Local interaction mockup. Role switching simulates two separate people.
class ServiceExchangeScreen extends StatefulWidget {
  const ServiceExchangeScreen({super.key});
  @override
  State<ServiceExchangeScreen> createState() => _ServiceExchangeScreenState();
}

class _ServiceExchangeScreenState extends State<ServiceExchangeScreen> {
  String _role = 'A';
  String _offering = 'Two hours of gardening help';
  String _lookingFor = 'A math tutoring session';
  DateTime _expires = DateTime.now().add(const Duration(days: 3));
  final _replies = <_TradeReply>[];
  bool _closed = false;
  bool get _expired => !DateTime.now().isBefore(_expires);
  bool get _open => !_expired && !_closed;

  String _expiryLabel(BuildContext context) {
    final local = MaterialLocalizations.of(context);
    return '${local.formatMediumDate(_expires)} at ${local.formatTimeOfDay(TimeOfDay.fromDateTime(_expires))}';
  }

  Future<void> _createOffer() async {
    final offering = TextEditingController();
    final request = TextEditingController();
    final form = GlobalKey<FormState>();
    var days = 3;
    final submitted = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                  title: const Text('Create a trade offer'),
                  scrollable: true,
                  content: Form(
                      key: form,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                            controller: offering,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                labelText: 'What Person A offers'),
                            validator: _required),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: request,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                labelText: 'What Person A wants in return'),
                            validator: _required),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                            initialValue: days,
                            decoration: const InputDecoration(
                                labelText: 'Offer expires in'),
                            items: [
                              for (final value in [1, 3, 7])
                                DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                        '$value ${value == 1 ? 'day' : 'days'}'))
                            ],
                            onChanged: (value) =>
                                setDialogState(() => days = value ?? 3)),
                      ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text('Create offer'))
                  ],
                )));
    if (submitted == true && mounted) {
      setState(() {
        _offering = offering.text.trim();
        _lookingFor = request.text.trim();
        _expires = DateTime.now().add(Duration(days: days));
        _replies.clear();
        _closed = false;
      });
    }
    // Dialog closing animations may still use these controllers.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    offering.dispose();
    request.dispose();
  }

  static String? _required(String? value) =>
      value == null || value.trim().isEmpty
          ? 'Please add a description.'
          : null;

  Future<void> _offerTrade() async {
    if (!_open) {
      setState(() {});
      return;
    }
    final offerings = TextEditingController();
    final form = GlobalKey<FormState>();
    final submitted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Offer a trade'),
              scrollable: true,
              content: Form(
                  key: form,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'What can Person B offer in return? Add each offering on a separate line.'),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: offerings,
                            minLines: 3,
                            maxLines: 6,
                            decoration: const InputDecoration(
                                labelText: 'Your offerings',
                                hintText:
                                    'One math tutoring session\nPractice worksheets'),
                            validator: _required),
                      ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Submit trade'))
              ],
            ));
    if (submitted == true && mounted) {
      setState(() {
        if (_open) {
          _replies.add(_TradeReply(offerings.text
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList()));
        }
      });
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    offerings.dispose();
  }

  void _decide(_TradeReply reply, bool accept) {
    if (_role != 'A' || !_open || reply.status != 'Pending') {
      setState(() {});
      return;
    }
    setState(() {
      reply.status = accept ? 'Accepted' : 'Declined';
      if (accept) {
        _closed = true;
        for (final other in _replies) {
          if (other != reply && other.status == 'Pending') {
            other.status = 'Closed';
          }
        }
      }
    });
  }

  Widget _panel(BuildContext context,
      {required String heading,
      required List<String> offerings,
      required bool isA}) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: isA ? colors.primaryContainer : colors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(heading, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          for (final item in offerings)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(item, style: theme.textTheme.bodyLarge))
                    ])),
        ]));
  }

  Widget _comparison(BuildContext context, _TradeReply reply) {
    final theme = Theme.of(context);
    return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text('Trade proposal',
                        style: theme.textTheme.titleLarge)),
                Chip(
                    label: Text(reply.status == 'Pending' && _expired
                        ? 'Expired'
                        : reply.status))
              ]),
              const SizedBox(height: 16),
              LayoutBuilder(builder: (context, constraints) {
                final a = _panel(context,
                    heading: 'Person A gives',
                    offerings: [_offering],
                    isA: true);
                final b = _panel(context,
                    heading: 'Person B gives',
                    offerings: reply.offerings,
                    isA: false);
                if (constraints.maxWidth < 600) {
                  return Column(children: [
                    a,
                    const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.swap_vert_rounded)),
                    b
                  ]);
                }
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: a),
                      const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(Icons.swap_horiz_rounded)),
                      Expanded(child: b)
                    ]);
              }),
              const SizedBox(height: 20),
              if (reply.status == 'Pending' && _open)
                if (_role == 'A')
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    FilledButton.icon(
                        onPressed: () => _decide(reply, true),
                        icon: const Icon(Icons.check),
                        label: const Text('Accept trade')),
                    OutlinedButton.icon(
                        onPressed: () => _decide(reply, false),
                        icon: const Icon(Icons.close),
                        label: const Text('Decline trade')),
                  ])
                else
                  const Text(
                      'Waiting for Person A to review. Switch to Person A above to try accepting or declining.'),
              if (reply.status == 'Accepted')
                const Text(
                    'Trade accepted in this mockup. No real booking or agreement has been created.'),
              if (reply.status == 'Declined')
                const Text(
                    'Person A declined this proposal. Person B can offer a different trade.'),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
            title: const Text('Service Exchange'),
            actions: const [ThemeToggleButton()]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('A skill for a skill.',
                                      style: theme.textTheme.headlineMedium),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Offer what you can share. Find a trade that works for both of you.',
                                      style: theme.textTheme.bodyLarge),
                                  const SizedBox(height: 20),
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.tertiaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: const Text(
                                          'Interactive mockup · The starting offer is an example. Switch roles to try both sides. Changes stay on this screen and are not saved or sent.')),
                                  const SizedBox(height: 20),
                                  SegmentedButton<String>(
                                      segments: const [
                                        ButtonSegment(
                                            value: 'A',
                                            label: Text('Person A'),
                                            icon: Icon(Icons.person_outline)),
                                        ButtonSegment(
                                            value: 'B',
                                            label: Text('Person B'),
                                            icon: Icon(Icons.person_outline))
                                      ],
                                      selected: {
                                        _role
                                      },
                                      onSelectionChanged: (value) =>
                                          setState(() => _role = value.single)),
                                  const SizedBox(height: 24),
                                  Card(
                                      margin: EdgeInsets.zero,
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Person A’s offer',
                                                    style: theme
                                                        .textTheme.titleLarge),
                                                const SizedBox(height: 16),
                                                Text('Offering',
                                                    style: theme
                                                        .textTheme.labelLarge),
                                                const SizedBox(height: 6),
                                                Text(_offering,
                                                    style: theme
                                                        .textTheme.bodyLarge),
                                                const SizedBox(height: 16),
                                                Text('Looking for',
                                                    style: theme
                                                        .textTheme.labelLarge),
                                                const SizedBox(height: 6),
                                                Text(_lookingFor,
                                                    style: theme
                                                        .textTheme.bodyLarge),
                                                const SizedBox(height: 16),
                                                Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      Chip(
                                                          label: Text(_closed
                                                              ? 'Trade accepted'
                                                              : _expired
                                                                  ? 'Expired'
                                                                  : 'Open')),
                                                      Chip(
                                                          avatar: const Icon(
                                                              Icons.schedule,
                                                              size: 18),
                                                          label: Text(
                                                              'Expires ${_expiryLabel(context)}'))
                                                    ]),
                                                const SizedBox(height: 16),
                                                if (_role == 'A')
                                                  OutlinedButton.icon(
                                                      onPressed: _createOffer,
                                                      icon:
                                                          const Icon(Icons.add),
                                                      label: const Text(
                                                          'Create new offer'))
                                                else
                                                  FilledButton.icon(
                                                      onPressed: _open
                                                          ? _offerTrade
                                                          : null,
                                                      icon: const Icon(
                                                          Icons.swap_horiz),
                                                      label: const Text(
                                                          'Offer a trade')),
                                                if (!_open && !_closed)
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 12),
                                                      child: Text(
                                                          'This offer has expired. Person A can create a new offer.')),
                                              ]))),
                                  const SizedBox(height: 28),
                                  Text('Trade proposals',
                                      style: theme.textTheme.headlineSmall),
                                  const SizedBox(height: 16),
                                  if (_replies.isEmpty)
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                            'No proposals yet. Switch to Person B and offer a trade to compare both sides.',
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                    color: theme.colorScheme
                                                        .onSurfaceVariant))),
                                  for (final reply in _replies)
                                    _comparison(context, reply),
                                ])))))));
  }
}
