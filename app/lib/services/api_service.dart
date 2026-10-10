import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';

/// All calls to our backend go through here, with the login token attached.
/// Add new endpoints as methods on this class.
class ApiService {
  ApiService(this._getToken);

  final String? Function() _getToken;

  Future<Map<String, dynamic>> getMe() => _get('/api/me');

  Future<Map<String, dynamic>> _get(String path) async {
    final token = _getToken();
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}$path'),
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception('${response.statusCode}: ${body['message'] ?? body}');
    }
    return body;
  }
}
