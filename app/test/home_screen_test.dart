import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/screens/angel_chat_screen.dart';
import 'package:starter_app/screens/home_screen.dart';
import 'package:starter_app/services/api_service.dart';

void main() {
  testWidgets('guest help stays on home without sending a request',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home:
          HomeScreen(user: null, api: ApiService(() => null), onLogout: () {}),
    ));
    await tester.tap(find.text('I need help'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(AngelChatScreen), findsNothing);
    expect(find.text('Angel chat for guests is not available yet.'),
        findsOneWidget);
    expect(
        Navigator.of(tester.element(find.byType(HomeScreen))).canPop(), false);
    await tester.tap(find.byTooltip('New conversation'));
    await tester.pumpAndSettle();
    expect(find.text('I need help'), findsOneWidget);
  });

  testWidgets('signed-in help opens the backend chat inline', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(
        user: const UserProfile(sub: 'auth0|test', name: 'Sam Rivera'),
        api: ApiService(() => 'test-token'),
        onLogout: () {},
      ),
    ));
    expect(find.textContaining('Sam'), findsOneWidget);
    expect(find.byTooltip('Log out'), findsOneWidget);
    await tester.tap(find.text('I need help'));
    await tester.pumpAndSettle();
    final chat = tester.widget<AngelChatScreen>(find.byType(AngelChatScreen));
    expect(chat.embedded, isTrue);
    expect(find.text('How can I help you today, Sam?'), findsOneWidget);
    expect(
        Navigator.of(tester.element(find.byType(HomeScreen))).canPop(), false);
  });
}
