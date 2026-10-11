import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/screens/angel_chat_screen.dart';
import 'package:starter_app/services/api_service.dart';

class IntakeApi extends ApiService {
  IntakeApi() : super(() => 'token');
  bool fail = true;
  int confirmed = 0;
  final turns = <String>[];
  @override
  Future<Map<String, dynamic>> chat(
      {required String conversationId,
      required String turnId,
      required String message}) async {
    turns.add(turnId);
    if (fail) {
      fail = false;
      throw Exception('Temporary failure');
    }
    return {
      'assistantMessage': 'Please review your request.',
      'revision': 1,
      'missingFields': [],
      'draft': {
        'title': 'Garden help',
        'description': 'Weed the garden',
        'category': 'gardening',
        'location': 'Atlanta',
        'timing': 'Saturday',
        'supportMode': 'in_person',
        'skillsNeeded': [],
        'evidence': []
      }
    };
  }

  @override
  Future<Map<String, dynamic>> confirmRequest(String id, int revision) async {
    confirmed++;
    return {
      'request': {'id': 'saved'}
    };
  }
}

void main() {
  testWidgets('retry keeps one user bubble and review explicitly confirms',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(768, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final api = IntakeApi();
    await tester.pumpWidget(
        MaterialApp(home: AngelChatScreen(api: api, userName: 'Sam Rivera')));
    await tester.enterText(
        find.byType(TextField), 'Garden help Saturday in Atlanta');
    await tester.pump();
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Temporary failure'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(api.turns[0], api.turns[1]);
    expect(find.text('Garden help Saturday in Atlanta'), findsOneWidget);
    expect(api.confirmed, 0);
    await tester.tap(find.text('Review your request'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Confirm request'));
    await tester.tap(find.text('Confirm request'));
    await tester.pumpAndSettle();
    expect(api.confirmed, 1);
    expect(find.text('Request saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
