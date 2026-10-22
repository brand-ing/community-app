import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/screens/home_screen.dart';
import 'package:starter_app/screens/angel_chat_screen.dart';
import 'package:starter_app/services/demo_api_service.dart';

void main() {
  testWidgets('home prompt transfers once into guest Angel conversation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeScreen(user: null, api: DemoApiService(), onLogout: () {})));
    expect(find.text('“You are more capable, neighbor.”'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Help with my garden');
    await tester.pump();
    await tester.tap(find.byTooltip('Start a conversation'));
    await tester.pumpAndSettle();
    expect(find.byType(AngelChatScreen), findsOneWidget);
    expect(find.text('Help with my garden'), findsOneWidget);
    expect(find.text('How can I help you today, neighbor?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('signed in greeting uses first name', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeScreen(
            user: const UserProfile(sub: 'auth0|test', name: 'Sam Rivera'),
            api: DemoApiService(),
            onLogout: () {})));
    expect(find.text('“You are more capable, Sam.”'), findsOneWidget);
    expect(find.byTooltip('Log out'), findsOneWidget);
  });
  testWidgets('mobile menu preserves Community access', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
        home: HomeScreen(user: null, api: DemoApiService(), onLogout: () {})));
    expect(find.text('How can I help you,\nneighbor?'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Community'));
    await tester.pumpAndSettle();
    expect(find.text('Progress Over Perfection'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
