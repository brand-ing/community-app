import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/screens/community_screen.dart';
import 'package:starter_app/theme/angel_theme.dart';

void main() {
  testWidgets(
      'Community filters, article comments, bookmarks, and local posting work',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
        theme: buildAngelTheme(Brightness.light),
        home: const CommunityScreen(userName: 'Sam Rivera')));
    expect(find.text('Progress Over Perfection'), findsOneWidget);
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();
    expect(find.text('Progress Over Perfection'), findsNothing);
    expect(find.text('Start with one small act of kindness'), findsOneWidget);
    await tester.tap(find.byTooltip('Bookmark post'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
    await tester.tap(find.text('Read story'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(
        find.byType(TextField), 'A small act can make a difference.');
    await tester.pump();
    await tester.ensureVisible(find.text('Add comment'));
    await tester.tap(find.text('Add comment'));
    await tester.pumpAndSettle();
    expect(find.text('A small act can make a difference.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
    await tester.tap(find.byTooltip('Write a post'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to preview'));
    await tester.pumpAndSettle();
    expect(find.text('Please fill this in.'), findsNWidgets(2));
    await tester.enterText(
        find.byType(TextFormField).at(0), 'A friendly welcome');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Glad to be part of the community.');
    await tester.tap(find.text('Add to preview'));
    await tester.pumpAndSettle();
    expect(find.text('A friendly welcome'), findsOneWidget);
    expect(find.text('Sam'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final brightness in Brightness.values) {
    for (final width in [320.0, 768.0, 1440.0]) {
      testWidgets('Community and reader fit $width in $brightness',
          (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(MaterialApp(
            theme: buildAngelTheme(brightness), home: const CommunityScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Read story').first);
        await tester.tap(find.text('Read story').first);
        await tester.pumpAndSettle();
        expect(find.text('Conversation'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
