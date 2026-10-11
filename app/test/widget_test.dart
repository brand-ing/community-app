import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/main.dart';
import 'package:starter_app/screens/home_screen.dart';
import 'package:starter_app/screens/product_screen.dart';
import 'package:starter_app/services/api_service.dart';

void main() {
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
      expect(find.textContaining('Community listings and requests'),
          findsOneWidget);
    });
  }
}
