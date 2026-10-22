import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/main.dart';
import 'package:starter_app/theme/angel_theme.dart';
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
    await tester.tap(find.byTooltip('Back to Angel’s Nest'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
  });
  testWidgets('Volunteer menu filters paid tasks and opens details',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: VolunteerScreen(api: TestApi())));
    await tester.pumpAndSettle();
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
    await tester.pumpWidget(MaterialApp(
        home: AngelChatScreen(userName: '  Sam Rivera  ', api: TestApi())));
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
  testWidgets('Guests enter directly and sign-in is optional', (tester) async {
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    expect(find.text('Three ways to connect'), findsOneWidget);
    await tester.tap(find.text('Continue to the app'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('neighbor'), findsWidgets);
    await tester.tap(find.byTooltip('Sign in (optional)'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in / Register'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to Angel’s Nest'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
  for (final brightness in Brightness.values) {
    for (final width in [320.0, 768.0, 1440.0]) {
      testWidgets('$brightness screens fit width $width', (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(MaterialApp(
            theme: buildAngelTheme(brightness),
            home: ProductScreen(onContinue: () {})));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(MaterialApp(
            theme: buildAngelTheme(brightness),
            home: HomeScreen(user: null, api: TestApi(), onLogout: () {})));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Making Living Easier'), findsOneWidget);
        await tester.ensureVisible(find.text('Community'));
        await tester.tap(find.text('Community'));
        await tester.pumpAndSettle();
        expect(find.text('Progress Over Perfection'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Quick money options'), findsNothing);
        expect(find.text('Chat with Angel'), findsNothing);
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
        expect(
            find.text('How can I help you today, neighbor?'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Service Exchange'));
        await tester.tap(find.text('Service Exchange'));
        await tester.pumpAndSettle();
        expect(find.text('A skill for a skill.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class TestApi extends ApiService {
  TestApi() : super(() => 'test');
  @override
  Future<List<Map<String, dynamic>>> getOpportunities() async => [
        for (final (title, category) in [
          ('Lend a hand at a community garden', 'Volunteer'),
          ('Share your knowledge with a learner', 'Tutoring')
        ])
          {
            'title': title,
            'category': category,
            'host': 'Demo team',
            'time': 'Weekends',
            'location': 'Atlanta',
            'description': 'Fictional test offering',
            'isDemo': true
          }
      ];
  @override
  Future<Map<String, dynamic>> chat(
          {required String conversationId,
          required String turnId,
          required String message}) async =>
      {
        'assistantMessage': 'What kind of support would help?',
        'revision': 1,
        'draft': {
          'title': null,
          'description': null,
          'category': 'unknown',
          'location': null,
          'timing': null,
          'supportMode': 'unknown',
          'skillsNeeded': [],
          'evidence': []
        },
        'missingFields': [
          'title',
          'description',
          'category',
          'timing',
          'supportMode',
          'location'
        ]
      };
}
