import 'package:flutter/material.dart';
import '../utils/display_name.dart';
import '../widgets/theme_toggle_button.dart';

class AngelChatScreen extends StatefulWidget {
  const AngelChatScreen({super.key, this.userName});
  final String? userName;

  @override
  State<AngelChatScreen> createState() => _AngelChatScreenState();
}

class _AngelChatScreenState extends State<AngelChatScreen> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();
  final _messages = <({bool fromAngel, String text})>[];
  int _step = 0;

  String get _name => firstName(widget.userName);

  String get _greeting => 'How can I help you today, $_name?';

  void _send([String? suggestion]) {
    final message = (suggestion ?? _composer.text).trim();
    if (message.isEmpty) return;
    const followUps = [
      'Let\'s take this one step at a time. What kind of support would make things easier for you?',
      'When would you like help, and is this a one-time need or something ongoing?',
      'Would support in person or remotely work best? If in person, which neighborhood or area should we focus on?',
      'Thank you for sharing! Community help matching is coming soon. This preview conversation stays here while you explore; your answers have not been saved or sent to a community organization.',
    ];
    setState(() {
      if (_messages.isEmpty) _messages.add((fromAngel: true, text: _greeting));
      _messages.add((fromAngel: false, text: message));
      _messages.add((
        fromAngel: true,
        text: _step < followUps.length
            ? followUps[_step]
            : 'You can add more thoughts here. When community help matching is available, we will help you take the next step.'
      ));
      _step++;
      _composer.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Chat with Angel'),
          actions: const [ThemeToggleButton()]),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(children: [
          Expanded(
              child: _messages.isEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                      child: Column(children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              colors.primaryContainer,
                              colors.secondaryContainer
                            ]),
                            border: Border.all(color: colors.outlineVariant),
                          ),
                          child: Icon(Icons.auto_awesome_rounded,
                              size: 38, color: colors.primary),
                        ),
                        const SizedBox(height: 24),
                        Text('A little guidance from Angel',
                            style: theme.textTheme.labelLarge
                                ?.copyWith(color: colors.primary)),
                        const SizedBox(height: 16),
                        Text(_greeting,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w500, height: 1.25)),
                        const SizedBox(height: 18),
                        Text(
                            'You do not have to figure it all out alone. Tell me what you need a helping hand with.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: colors.onSurfaceVariant, height: 1.6)),
                        const SizedBox(height: 32),
                        Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final suggestion in [
                                'I need help with a task',
                                'I could use some support',
                                'I am not sure where to start'
                              ])
                                ActionChip(
                                    label: Text(suggestion),
                                    onPressed: () => _send(suggestion)),
                            ]),
                      ]),
                    ))
                  : ListView.separated(
                      controller: _scroll,
                      padding: const EdgeInsets.all(24),
                      itemCount: _messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Align(
                          alignment: message.fromAngel
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: FractionallySizedBox(
                              widthFactor: .9,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: message.fromAngel
                                      ? colors.surface
                                      : colors.primaryContainer,
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: colors.outlineVariant),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(message.fromAngel ? 'Angel' : 'You',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                  color: colors.primary)),
                                      const SizedBox(height: 8),
                                      SelectableText(message.text,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(height: 1.5)),
                                    ]),
                              )),
                        );
                      },
                    )),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: colors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                        color: colors.shadow.withAlpha(15),
                        blurRadius: 24,
                        offset: const Offset(0, 6))
                  ],
                ),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: TextField(
                    controller: _composer,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Tell Angel what is on your mind...',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  )),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _composer,
                    builder: (context, value, _) => IconButton.filled(
                      tooltip: 'Send message',
                      onPressed:
                          value.text.trim().isEmpty ? null : () => _send(),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                  ),
                ]),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
              child: Text('Guided preview · This conversation is not saved.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant))),
        ]),
      ))),
    );
  }
}
