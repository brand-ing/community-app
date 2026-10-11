import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:starter_app/services/api_service.dart';

void main() {
  test('chat and confirmation use authenticated backend and preserve retry IDs',
      () async {
    final requests = <http.Request>[];
    final api =
        ApiService(() => 'auth0-token', client: MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode({'revision': 1}), 200);
    }));
    final id = ApiService.newId();
    final turn = ApiService.newId();
    await api.chat(conversationId: id, turnId: turn, message: 'Garden help');
    await api.chat(conversationId: id, turnId: turn, message: 'Garden help');
    await api.confirmRequest(id, 1);
    expect(requests[0].headers['Authorization'], 'Bearer auth0-token');
    expect(requests[0].body, requests[1].body);
    expect(requests[2].url.path, '/api/angel/$id/confirm');
    expect(jsonDecode(requests[2].body), {'revision': 1});
  });
  test('backend failures become useful errors rather than fake replies',
      () async {
    final api = ApiService(() => 'token',
        client: MockClient((_) async =>
            http.Response('{"message":"Angel is not configured."}', 503)));
    await expectLater(
        api.chat(
            conversationId: ApiService.newId(),
            turnId: ApiService.newId(),
            message: 'Help'),
        throwsA(predicate(
            (e) => e.toString().contains('Angel is not configured'))));
  });
}
