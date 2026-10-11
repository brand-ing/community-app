import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../utils/display_name.dart';
import '../widgets/theme_toggle_button.dart';
import 'community_article_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, this.userName});
  final String? userName;
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _posts = sampleCommunityPosts();
  String _category = 'Stories';
  Future<void> _read(CommunityPost post) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => CommunityArticleScreen(post: post)));
    if (mounted) setState(() {});
  }

  Future<void> _compose() async {
    final post = await showModalBottomSheet<CommunityPost>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) =>
            _PostComposer(author: firstName(widget.userName, fallback: 'You')));
    if (post != null && mounted) {
      setState(() {
        _posts.insert(0, post);
        _category = post.category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = _posts.where((post) => post.category == _category);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Community'), actions: const [ThemeToggleButton()]),
      floatingActionButton: FloatingActionButton(
          onPressed: _compose,
          tooltip: 'Write a post',
          child: const Icon(Icons.add)),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('A stronger you. A stronger community.',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text('Stories, advice, and updates from people helping people.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text(
                      'Community preview · Sample posts and local interactions. New posts, follows, bookmarks, likes, and comments are not published or saved after leaving this page.')),
              const SizedBox(height: 20),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final category in ['Stories', 'Tips', 'Announcements'])
                  ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category))
              ]),
              const SizedBox(height: 24),
              for (final post in visible)
                Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    CircleAvatar(
                                        child:
                                            Text(post.author.substring(0, 1))),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(post.author,
                                              style:
                                                  theme.textTheme.labelLarge),
                                          Text(
                                              'Preview ${post.category.toLowerCase()}',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant))
                                        ])),
                                    TextButton(
                                        onPressed: () => setState(() =>
                                            post.following = !post.following),
                                        child: Text(post.following
                                            ? 'Following'
                                            : 'Follow'))
                                  ]),
                                  const SizedBox(height: 16),
                                  InkWell(
                                      onTap: () => _read(post),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(post.title,
                                              style:
                                                  theme.textTheme.titleLarge))),
                                  const SizedBox(height: 10),
                                  Text(post.summary,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                              height: 1.5)),
                                  const SizedBox(height: 12),
                                  TextButton(
                                      onPressed: () => _read(post),
                                      child: const Text('Read story')),
                                  const Divider(),
                                  Row(children: [
                                    IconButton(
                                        tooltip: post.liked
                                            ? 'Unlike post'
                                            : 'Like post',
                                        onPressed: () => setState(
                                            () => post.liked = !post.liked),
                                        icon: Icon(post.liked
                                            ? Icons.favorite
                                            : Icons.favorite_border)),
                                    Text(post.liked ? '1' : '0'),
                                    const SizedBox(width: 12),
                                    IconButton(
                                        tooltip: 'Read and comment',
                                        onPressed: () => _read(post),
                                        icon: const Icon(
                                            Icons.chat_bubble_outline)),
                                    Text('${post.comments.length}'),
                                    const Spacer(),
                                    IconButton(
                                        tooltip: post.bookmarked
                                            ? 'Remove bookmark'
                                            : 'Bookmark post',
                                        onPressed: () => setState(() =>
                                            post.bookmarked = !post.bookmarked),
                                        icon: Icon(post.bookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border)),
                                  ]),
                                ])))),
            ])),
      )))),
    );
  }
}

class _PostComposer extends StatefulWidget {
  const _PostComposer({required this.author});
  final String author;
  @override
  State<_PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<_PostComposer> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _category = 'Stories';
  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Please fill this in.' : null;
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
        child: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
              key: _form,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Write a community post',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    const Text(
                        'This post will appear only in your local preview.'),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: _required),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        items: [
                          for (final category in [
                            'Stories',
                            'Tips',
                            'Announcements'
                          ])
                            DropdownMenuItem(
                                value: category, child: Text(category))
                        ],
                        onChanged: (value) =>
                            setState(() => _category = value ?? 'Stories')),
                    const SizedBox(height: 16),
                    TextFormField(
                        controller: _body,
                        minLines: 4,
                        maxLines: 10,
                        decoration:
                            const InputDecoration(labelText: 'Your post'),
                        validator: _required),
                    const SizedBox(height: 20),
                    FilledButton(
                        onPressed: () {
                          if (!_form.currentState!.validate()) return;
                          final text = _body.text.trim();
                          Navigator.pop(
                              context,
                              CommunityPost(
                                  title: _title.text.trim(),
                                  author: widget.author,
                                  category: _category,
                                  summary: text.length > 180
                                      ? '${text.substring(0, 180)}…'
                                      : text,
                                  body: text));
                        },
                        child: const Text('Add to preview')),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                  ])),
        ))),
      );
}
