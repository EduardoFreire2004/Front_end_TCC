import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'auth_service.dart';
import '../config/api_config.dart';

class ApiService {
  // Função auxiliar para retry
  static Future<T> _retryRequest<T>(
    Future<T> Function() request,
    int maxRetries,
  ) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        // Aguardar antes de tentar novamente
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    throw Exception('Número máximo de tentativas excedido');
  }

  // Função para verificar e renovar token se necessário
  static Future<void> _ensureValidToken() async {
    if (AuthService.isAuthenticated) {
      await AuthService.checkAndRefreshTokenIfNeeded();
    }
  }

  // GET
  static Future<http.Response> get(String endpoint) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final headers = AuthService.getAuthHeaders();
      return await http
          .get(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: headers)
          .timeout(ApiConfig.requestTimeout);
    }, ApiConfig.maxRetries);
  }

  // POST
  static Future<http.Response> post(String endpoint, dynamic body) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final headers = AuthService.getAuthHeaders();

      return await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(ApiConfig.requestTimeout);
    }, ApiConfig.maxRetries);
  }

  // POST para cadastro (com timeout maior)
  static Future<http.Response> postForRegistration(
    String endpoint,
    dynamic body,
  ) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final headers = AuthService.getAuthHeaders();

      return await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(ApiConfig.registrationTimeout);
    }, ApiConfig.maxRetries);
  }

  // PUT
  static Future<http.Response> put(String endpoint, dynamic body) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final headers = AuthService.getAuthHeaders();

      return await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(ApiConfig.requestTimeout);
    }, ApiConfig.maxRetries);
  }

  // DELETE
  static Future<http.Response> delete(String endpoint) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final headers = AuthService.getAuthHeaders();
      return await http
          .delete(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: headers)
          .timeout(ApiConfig.requestTimeout);
    }, ApiConfig.maxRetries);
  }

  // GET por ID (extra, se precisar)
  static Future<http.Response> getID(String endpoint) async {
    return await _retryRequest(() async {
      await _ensureValidToken();
      final client = http.Client();
      try {
        final headers = AuthService.getAuthHeaders();
        return await client
            .get(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: headers)
            .timeout(ApiConfig.requestTimeout);
      } finally {
        client.close();
      }
    }, ApiConfig.maxRetries);
  }

  // POST sem autenticação (para login/cadastro)
  static Future<http.Response> postWithoutAuth(
    String endpoint,
    dynamic body,
  ) async {
    return await _retryRequest(() async {
      return await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode(body),
          )
          .timeout(ApiConfig.requestTimeout);
    }, ApiConfig.maxRetries);
  }
}
