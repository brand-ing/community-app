import 'dart:math' as math;
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/display_name.dart';
import '../widgets/nest_brand.dart';
import '../widgets/theme_toggle_button.dart';
import 'angel_chat_screen.dart';
import 'volunteer_screen.dart';
import 'service_exchange_screen.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.user,
      required this.api,
      required this.onLogout,
      this.onLogin,
      this.onBack});
  final UserProfile? user;
  final ApiService api;
  final VoidCallback onLogout;
  final VoidCallback? onLogin;
  final VoidCallback? onBack;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _prompt = TextEditingController();
  String get _name => firstName(widget.user?.name);
  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }

  void _chat([String? message]) {
    final text = message?.trim();
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => AngelChatScreen(
            userName: widget.user?.name,
            api: widget.api,
            initialMessage: text)));
    if (text != null && text.isNotEmpty) _prompt.clear();
  }

  void _select(int index) {
    if (index == 1) {
      _chat();
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => index == 0
            ? VolunteerScreen(api: widget.api)
            : const ServiceExchangeScreen()));
  }

  void _community() => Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => CommunityScreen(userName: widget.user?.name)));
  void _profile() {
    if (widget.user == null) {
      widget.onLogin?.call();
      return;
    }
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Your profile'),
                content: Text('$_name\n${widget.user?.email ?? ''}'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return LayoutBuilder(builder: (context, layout) {
      final wide = layout.maxWidth >= 700;
      return Scaffold(
        appBar: AppBar(backgroundColor: colors.surface, actions: [
          if (wide) const ThemeToggleButton(),
          IconButton(
              onPressed: _profile,
              tooltip:
                  widget.user == null ? 'Sign in (optional)' : 'Your profile',
              icon: Icon(widget.user == null
                  ? Icons.account_circle_outlined
                  : Icons.account_circle)),
          if (widget.user != null)
            IconButton(
                onPressed: widget.onLogout,
                tooltip: 'Log out',
                icon: const Icon(Icons.logout)),
          if (widget.onBack != null && wide)
            IconButton(
                onPressed: widget.onBack,
                tooltip: 'Back to Angel’s Nest',
                icon: const Icon(Icons.arrow_back_rounded)),
          const SizedBox(width: 12),
        ]),
        drawer: Drawer(
            child: SafeArea(
                child: ListView(padding: const EdgeInsets.all(20), children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: NestWordmark()),
          Text('Welcome, $_name.', style: theme.textTheme.titleMedium),
          const SizedBox(height: 24),
          for (final (label, icon, index) in [
            ('I want to volunteer', Icons.favorite_border_rounded, 0),
            ('I need help', Icons.search_rounded, 1),
            ('Service Exchange', Icons.swap_horiz_rounded, 2)
          ])
            ListTile(
                leading: Icon(icon),
                title: Text(label),
                onTap: () {
                  Navigator.pop(context);
                  _select(index);
                }),
          ListTile(
              leading: const Icon(Icons.people_outline_rounded),
              title: const Text('Community'),
              onTap: () {
                Navigator.pop(context);
                _community();
              }),
          const Divider(),
          if (widget.user == null)
            ListTile(
                leading: const Icon(Icons.login_rounded),
                title: const Text('Sign in (optional)'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onLogin?.call();
                }),
          const Row(children: [
            Expanded(child: Text('Appearance')),
            ThemeToggleButton()
          ]),
          if (widget.onBack != null)
            ListTile(
                leading: const Icon(Icons.arrow_back_rounded),
                title: const Text('About Angel’s Nest'),
                onTap: widget.onBack),
        ]))),
        body: SafeArea(
            child: LayoutBuilder(
                builder: (context, viewport) => SingleChildScrollView(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          wide ? 32 : 20, 24, wide ? 32 : 20, 24),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: math.max(0, viewport.maxHeight - 48)),
                          child: Column(
                              mainAxisAlignment: wide
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                Center(
                                    child: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 720),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (wide) ...[
                                                Text('AN',
                                                    semanticsLabel:
                                                        'Angel’s Nest',
                                                    style: theme
                                                        .textTheme.displayLarge
                                                        ?.copyWith(
                                                            color:
                                                                colors.primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: -4)),
                                                const SizedBox(height: 12),
                                                Text('Making Living Easier',
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            color: colors
                                                                .onSurfaceVariant,
                                                            letterSpacing: 2)),
                                                const SizedBox(height: 28),
                                                Text(
                                                    '“You are more capable, $_name.”',
                                                    textAlign: TextAlign.center,
                                                    style: theme.textTheme
                                                        .headlineSmall),
                                              ] else ...[
                                                Text(
                                                    'How can I help you,\n$_name?',
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme.headlineLarge
                                                        ?.copyWith(
                                                            height: 1.25)),
                                                const SizedBox(height: 12),
                                                Text('Making Living Easier',
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            color: colors
                                                                .onSurfaceVariant)),
                                              ],
                                              const SizedBox(height: 28),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    for (final (
                                                          label,
                                                          icon,
                                                          index
                                                        ) in [
                                                      (
                                                        'I want to volunteer',
                                                        Icons
                                                            .favorite_border_rounded,
                                                        0
                                                      ),
                                                      (
                                                        'I need help',
                                                        Icons.search_rounded,
                                                        1
                                                      ),
                                                      (
                                                        'Service Exchange',
                                                        Icons
                                                            .swap_horiz_rounded,
                                                        2
                                                      )
                                                    ])
                                                      Expanded(
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              child: TextButton(
                                                                  onPressed: () =>
                                                                      _select(
                                                                          index),
                                                                  style: TextButton.styleFrom(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              12,
                                                                          horizontal:
                                                                              4)),
                                                                  child: Column(
                                                                      children: [
                                                                        Icon(
                                                                            icon,
                                                                            size:
                                                                                30),
                                                                        const SizedBox(
                                                                            height:
                                                                                8),
                                                                        Text(
                                                                            label,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: theme.textTheme.labelMedium?.copyWith(color: colors.primary))
                                                                      ])))),
                                                  ]),
                                              const SizedBox(height: 12),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: colors
                                                          .surfaceContainerLow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                      border: Border.all(
                                                          color: colors
                                                              .outlineVariant)),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 4, 6, 4),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            child: TextField(
                                                                controller:
                                                                    _prompt,
                                                                minLines: 1,
                                                                maxLines: 4,
                                                                maxLength: 2000,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .sentences,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .send,
                                                                onSubmitted:
                                                                    (value) {
                                                                  if (value
                                                                      .trim()
                                                                      .isNotEmpty) {
                                                                    _chat(
                                                                        value);
                                                                  }
                                                                },
                                                                decoration: const InputDecoration(
                                                                    hintText:
                                                                        'Tell Angel what you need…',
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    enabledBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    focusedBorder:
                                                                        InputBorder
                                                                            .none))),
                                                        ValueListenableBuilder<
                                                                TextEditingValue>(
                                                            valueListenable:
                                                                _prompt,
                                                            builder: (_, value, __) => IconButton.filled(
                                                                tooltip:
                                                                    'Start a conversation',
                                                                onPressed: value
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? null
                                                                    : () => _chat(
                                                                        value
                                                                            .text),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .arrow_upward_rounded))),
                                                      ])),
                                              const SizedBox(height: 16),
                                              TextButton.icon(
                                                  onPressed: _community,
                                                  icon: const Icon(
                                                      Icons
                                                          .people_outline_rounded,
                                                      size: 18),
                                                  label:
                                                      const Text('Community')),
                                              const SizedBox(height: 8),
                                              Text(
                                                  widget.api.isDemo
                                                      ? 'Demo experience · Conversations and listings are previews.'
                                                      : 'A little support starts with a conversation.',
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: colors
                                                              .onSurfaceVariant)),
                                            ]))),
                                if (wide) const SizedBox(height: 80),
                              ])),
                    )))),
      );
    });
  }
}
