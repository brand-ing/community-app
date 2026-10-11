import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/community_post.dart';
import '../theme/angel_theme.dart';
import '../widgets/theme_toggle_button.dart';

class CommunityArticleScreen extends StatefulWidget {
  const CommunityArticleScreen({super.key, required this.post});
  final CommunityPost post;
  @override
  State<CommunityArticleScreen> createState() => _CommunityArticleScreenState();
}

class _CommunityArticleScreenState extends State<CommunityArticleScreen> {
  final _comment = TextEditingController();
  void _sendComment() {
    final text = _comment.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.post.comments.add(text);
      _comment.clear();
    });
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(title: const Text('Community'), actions: [
        IconButton(
            tooltip: post.bookmarked ? 'Remove bookmark' : 'Bookmark article',
            icon:
                Icon(post.bookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () =>
                setState(() => post.bookmarked = !post.bookmarked)),
        const ThemeToggleButton(),
      ]),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Chip(label: Text(post.category)),
              const SizedBox(height: 16),
              Text(post.title, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 20),
              Row(children: [
                CircleAvatar(child: Text(post.author.substring(0, 1))),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('${post.author} · Preview post',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)))
              ]),
              const SizedBox(height: 24),
              Text(post.summary,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.7)),
              if (post.quote != null) ...[
                const SizedBox(height: 24),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: NestPalette.of(context).tints[1],
                        borderRadius: BorderRadius.circular(16)),
                    child: Text('“${post.quote}”',
                        style:
                            theme.textTheme.titleLarge?.copyWith(fontSize: 20)))
              ],
              const SizedBox(height: 24),
              for (final paragraph in post.body.split('\n\n'))
                Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(paragraph,
                        style:
                            theme.textTheme.bodyLarge?.copyWith(height: 1.8))),
              const Divider(),
              Wrap(spacing: 12, runSpacing: 8, children: [
                TextButton.icon(
                    onPressed: () => setState(() => post.liked = !post.liked),
                    icon: Icon(
                        post.liked ? Icons.favorite : Icons.favorite_border),
                    label: Text(post.liked ? 'Liked' : 'Like')),
                TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                          text:
                              '${post.title}\nBy ${post.author}\n\n${post.body}'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Article copied')));
                      }
                    },
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('Copy article')),
              ]),
              const SizedBox(height: 24),
              Text('Conversation', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text('Comments are local to this preview.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              if (post.comments.isEmpty)
                const Text('Be the first to add a thought.'),
              for (final comment in post.comments)
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('You',
                                      style: theme.textTheme.labelLarge),
                                  const SizedBox(height: 6),
                                  Text(comment)
                                ])))),
              const SizedBox(height: 16),
              TextField(
                  controller: _comment,
                  minLines: 2,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(labelText: 'Add a thought')),
              const SizedBox(height: 12),
              ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _comment,
                  builder: (context, value, _) => FilledButton(
                      onPressed:
                          value.text.trim().isEmpty ? null : _sendComment,
                      child: const Text('Add comment'))),
              const SizedBox(height: 24),
            ])),
      )))),
    );
  }
}
