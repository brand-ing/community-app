import 'package:flutter/material.dart';
import '../utils/display_name.dart';
import '../services/api_service.dart';
import '../theme/angel_theme.dart';
import '../widgets/theme_toggle_button.dart';

class AngelChatScreen extends StatefulWidget {
  const AngelChatScreen(
      {super.key, this.userName, required this.api, this.initialMessage});
  final ApiService api;
  final String? userName;
  final String? initialMessage;

  @override
  State<AngelChatScreen> createState() => _AngelChatScreenState();
}

class _AngelChatScreenState extends State<AngelChatScreen> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();
  final _messages = <({bool fromAngel, String text})>[];
  final _conversationId = ApiService.newId();
  String? _turnId;
  String? _pending;
  String? _error;
  Map<String, dynamic>? _response;
  bool _busy = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final message = widget.initialMessage?.trim();
    if (message != null && message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _send(message);
      });
    }
  }

  String get _name => firstName(widget.userName);

  String get _greeting => 'How can I help you today, $_name?';

  Future<void> _send([String? suggestion]) async {
    if (_busy || _saved) return;
    final message = _pending ?? (suggestion ?? _composer.text).trim();
    if (message.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
      if (_pending == null) {
        if (_messages.isEmpty) {
          _messages.add((fromAngel: true, text: _greeting));
        }
        _messages.add((fromAngel: false, text: message));
        _pending = message;
        _turnId = ApiService.newId();
        _composer.clear();
      }
    });
    try {
      final result = await widget.api.chat(
          conversationId: _conversationId, turnId: _turnId!, message: message);
      if (!mounted) return;
      setState(() {
        _response = result;
        _pending = null;
        _turnId = null;
        _messages
            .add((fromAngel: true, text: result['assistantMessage'] as String));
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _confirm() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.api
          .confirmRequest(_conversationId, _response!['revision'] as int);
      if (mounted) setState(() => _saved = true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _review() {
    final draft = _response!['draft'] as Map<String, dynamic>;
    final missing = _response!['missingFields'] as List<dynamic>;
    return ExpansionTile(
        title: Text(_saved
            ? (widget.api.isDemo ? 'Demo request complete' : 'Request saved')
            : 'Review your request'),
        children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final key in [
                      'title',
                      'description',
                      'category',
                      'location',
                      'timing',
                      'supportMode',
                      'skillsNeeded'
                    ])
                      Text('$key: ${draft[key] ?? 'Not provided'}'),
                    const SizedBox(height: 12),
                    Text(missing.isEmpty
                        ? 'Check the details. Tell Angel any corrections before confirming.'
                        : 'Still needed: ${missing.join(', ')}'),
                    FilledButton(
                        onPressed: missing.isEmpty &&
                                !_busy &&
                                !_saved &&
                                _pending == null
                            ? _confirm
                            : null,
                        child: Text(_saved
                            ? (widget.api.isDemo
                                ? 'Completed in this demo'
                                : 'Saved to Angel’s Nest')
                            : (widget.api.isDemo
                                ? 'Confirm demo request'
                                : 'Confirm request'))),
                  ])),
        ]);
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
    final palette = NestPalette.of(context);
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
                              colors.tertiaryContainer
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
                                      ? palette.quote
                                      : colors.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(18),
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
          if (_busy) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(child: Text(_error!)),
                  TextButton(
                      onPressed: _busy
                          ? null
                          : (_pending != null ? () => _send() : _confirm),
                      child: const Text('Retry'))
                ])),
          if (_response != null) _review(),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
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
                    enabled: !_busy && !_saved && _pending == null,
                    maxLength: 2000,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Tell Angel what is on your mind...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  )),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _composer,
                    builder: (context, value, _) => IconButton.filled(
                      tooltip: 'Send message',
                      onPressed: value.text.trim().isEmpty ||
                              _busy ||
                              _saved ||
                              _pending != null
                          ? null
                          : () => _send(),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                  ),
                ]),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
              child: Text(
                  widget.api.isDemo
                      ? 'Demo conversation · Scripted replies, no live Gemini or database. Nothing is published; resets when you reload.'
                      : 'Angel uses Google Gemini. Conversation drafts are saved for your account. Avoid private addresses or sensitive information.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant))),
        ]),
      ))),
    );
  }
}
