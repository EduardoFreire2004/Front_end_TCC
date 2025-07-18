import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://localhost:5209/api';

  static Future<http.Response> get(String endpoint) async {
    return await http.get(Uri.parse('$baseUrl$endpoint'));
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    return await http.delete(Uri.parse('$baseUrl$endpoint'));
  }


  static Future<http.Response> getID(String endpoint) async {
    final client = http.Client();
    try {
      return await client.get(
        Uri.parse('$baseUrl$endpoint'),
      );
    } finally {
      client.close();
    }
  }
}
