import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  ApiService(this._getToken, {http.Client? client})
      : _client = client ?? http.Client();
  final String? Function() _getToken;
  final http.Client _client;
  bool get isDemo => false;
  static String newId() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 15) | 64;
    b[8] = (b[8] & 63) | 128;
    final h = b.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }

  Future<Map<String, dynamic>> getMe() => _request('/api/me');
  Future<List<Map<String, dynamic>>> getOpportunities() async =>
      (await _request('/api/opportunities'))['opportunities']
          .cast<Map<String, dynamic>>();
  Future<Map<String, dynamic>> chat(
          {required String conversationId,
          required String turnId,
          required String message}) =>
      _request('/api/angel/chat', data: {
        'conversationId': conversationId,
        'turnId': turnId,
        'message': message
      });
  Future<Map<String, dynamic>> confirmRequest(String id, int revision) =>
      _request('/api/angel/$id/confirm', data: {'revision': revision});
  Future<Map<String, dynamic>> _request(String path,
      {Map<String, dynamic>? data}) async {
    final token = _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token'
    };
    final url = Uri.parse('${Config.apiBaseUrl}$path');
    final response = await (data == null
            ? _client.get(url, headers: headers)
            : _client.post(url, headers: headers, body: jsonEncode(data)))
        .timeout(const Duration(seconds: 70));
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Unreadable server response. Please retry.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          body['message'] ?? 'Request failed (${response.statusCode}).');
    }
    return body;
  }
}
