import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5209/api';

  // GET
  static Future<http.Response> get(String endpoint) async {
    final headers = AuthService.getAuthHeaders();
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  // POST
  static Future<http.Response> post(String endpoint, dynamic body) async {
    final headers = AuthService.getAuthHeaders();

    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
  }

  // PUT
  static Future<http.Response> put(String endpoint, dynamic body) async {
    final headers = AuthService.getAuthHeaders();

    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
  }

  // DELETE
  static Future<http.Response> delete(String endpoint) async {
    final headers = AuthService.getAuthHeaders();
    return await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  // GET por ID (extra, se precisar)
  static Future<http.Response> getID(String endpoint) async {
    final client = http.Client();
    try {
      final headers = AuthService.getAuthHeaders();
      return await client.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    } finally {
      client.close();
    }
  }
}
