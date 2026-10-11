import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/main.dart';
import 'package:starter_app/screens/angel_chat_screen.dart';
import 'package:starter_app/screens/home_screen.dart';
import 'package:starter_app/screens/volunteer_screen.dart';
import 'package:starter_app/screens/product_screen.dart';
import 'package:starter_app/services/api_service.dart';

void main() {
  testWidgets('Theme toggle applies across navigation and back',
      (tester) async {
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch to dark mode'));
    await tester.pumpAndSettle();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark);
    await tester.tap(find.text('Continue to the app'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);
    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pumpAndSettle();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light);
    await tester.tap(find.byTooltip('Back to AngelNest'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
  });
  testWidgets('Volunteer menu filters paid tasks and opens details',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: VolunteerScreen()));
    expect(find.text('Lend a hand at a community garden'), findsOneWidget);
    await tester.tap(find.text('Tutoring'));
    await tester.pumpAndSettle();
    expect(find.text('Tutoring opportunities'), findsOneWidget);
    expect(find.text('Lend a hand at a community garden'), findsNothing);
    expect(find.text('Share your knowledge with a learner'), findsOneWidget);
    await tester.ensureVisible(find.text('View details'));
    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Example listing. Contact and sign-up'),
        findsOneWidget);
    await tester.tap(find.text('Back to listings'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Angel greets the user and accepts messages', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: AngelChatScreen(userName: '  Sam Rivera  ')));
    expect(find.text('How can I help you today, Sam?'), findsOneWidget);
    expect(
        tester
            .widget<IconButton>(find.byWidgetPredicate((widget) =>
                widget is IconButton && widget.tooltip == 'Send message'))
            .onPressed,
        isNull);
    await tester.enterText(
        find.byType(TextField), 'I need help with gardening');
    await tester.pump();
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(find.text('I need help with gardening'), findsOneWidget);
    expect(
        find.byWidgetPredicate((widget) =>
            widget is SelectableText &&
            (widget.data?.contains('What kind of support') ?? false)),
        findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Product page opens sign-in and returns', (tester) async {
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    expect(find.text('Three ways to connect'), findsOneWidget);
    await tester.tap(find.text('Continue to the app'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in / Register'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to AngelNest'));
    await tester.pumpAndSettle();
    expect(find.text('Three ways to connect'), findsOneWidget);
  });
  for (final width in [320.0, 768.0, 1440.0]) {
    testWidgets('Screens fit width $width', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester
          .pumpWidget(MaterialApp(home: ProductScreen(onContinue: () {})));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(MaterialApp(
          home: HomeScreen(
              user: null, api: ApiService(() => null), onLogout: () {})));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('I want to volunteer'));
      await tester.tap(find.text('I want to volunteer'));
      await tester.pumpAndSettle();
      expect(find.text('Volunteer offerings'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('I need help'));
      await tester.tap(find.text('I need help'));
      await tester.pumpAndSettle();
      expect(find.text('How can I help you today, neighbor?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
