import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/screens/service_exchange_screen.dart';
import 'package:starter_app/theme/angel_theme.dart';

Future<void> submitReply(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text('Person B'));
  await tester.tap(find.text('Person B'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Offer a trade'));
  await tester.tap(find.text('Offer a trade'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), text);
  await tester.tap(find.text('Submit trade'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.ensureVisible(find.text('Person A'));
  await tester.tap(find.text('Person A'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'Offers validate, show both sides, and can be declined then accepted',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
        theme: buildAngelTheme(Brightness.light),
        home: const ServiceExchangeScreen()));
    await tester.tap(find.text('Person B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offer a trade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit trade'));
    await tester.pumpAndSettle();
    expect(find.text('Please add a description.'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 350));
    await submitReply(tester, 'One tutoring session\nPractice worksheets');
    expect(find.text('Person A gives'), findsOneWidget);
    expect(find.text('Person B gives'), findsOneWidget);
    expect(find.text('One tutoring session'), findsOneWidget);
    expect(find.text('Practice worksheets'), findsOneWidget);
    final a = tester.getTopLeft(find.text('Person A gives'));
    final b = tester.getTopLeft(find.text('Person B gives'));
    expect(a.dy, b.dy);
    expect(b.dx, greaterThan(a.dx));
    await tester.ensureVisible(find.text('Decline trade'));
    await tester.tap(find.text('Decline trade'));
    await tester.pumpAndSettle();
    expect(find.text('Declined'), findsOneWidget);
    await submitReply(tester, 'Two tutoring sessions');
    await tester.ensureVisible(find.text('Accept trade'));
    await tester.tap(find.text('Accept trade'));
    await tester.pumpAndSettle();
    expect(find.text('Accepted'), findsOneWidget);
    await tester.ensureVisible(find.text('Person B'));
    await tester.tap(find.text('Person B'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Offer a trade'))
            .onPressed,
        isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Person A creates an offer with an expiration', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
        theme: buildAngelTheme(Brightness.light),
        home: const ServiceExchangeScreen()));
    await tester.tap(find.text('Create new offer'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).at(0), 'A website review');
    await tester.enterText(find.byType(TextFormField).at(1), 'Logo design');
    await tester.tap(find.text('3 days'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1 day').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create offer'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('A website review'), findsOneWidget);
    expect(find.text('Logo design'), findsOneWidget);
    final date = MaterialLocalizations.of(
            tester.element(find.byType(ServiceExchangeScreen)))
        .formatMediumDate(DateTime.now().add(const Duration(days: 1)));
    expect(find.textContaining('Expires $date'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
