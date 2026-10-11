import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/services/demo_api_service.dart';

void main() {
  test('local demo completes intake without any backend and retry is stable',
      () async {
    final api = DemoApiService();
    expect(api.isDemo, true);
    expect((await api.getOpportunities()).length, 6);
    final first = await api.chat(
        conversationId: 'demo', turnId: 'one', message: 'Help with my garden');
    expect(
        await api.chat(
            conversationId: 'demo',
            turnId: 'one',
            message: 'Help with my garden'),
        first);
    await api.chat(
        conversationId: 'demo', turnId: 'two', message: 'Saturday morning');
    final last = await api.chat(
        conversationId: 'demo', turnId: 'three', message: 'Midtown Atlanta');
    expect(last['missingFields'], isEmpty);
    expect(last['draft']['description'], 'Help with my garden');
    expect(last['draft']['timing'], 'Saturday morning');
    expect(last['draft']['location'], 'Midtown Atlanta');
    expect((await api.confirmRequest('demo', 3))['request']['isDemo'], true);
  });
}
