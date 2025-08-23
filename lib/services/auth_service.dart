import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/AuthResponseModel.dart';
import '../models/UsuarioModel.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5209/api';
  static String? _token;
  static String? _refreshToken;
  static UsuarioModel? _usuario;

  // Getters
  static String? get token => _token;
  static String? get refreshToken => _refreshToken;
  static UsuarioModel? get usuario => _usuario;
  static bool get isAuthenticated => _token != null;

  // Login
  static Future<AuthResponseModel> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(
          json.decode(response.body),
        );

        if (authResponse.success) {
          _token = authResponse.token;
          _refreshToken = authResponse.refreshToken;
          _usuario = authResponse.usuario;
        }

        return authResponse;
      } else {
        return AuthResponseModel(success: false);
      }
    } catch (e) {
      return AuthResponseModel(success: false);
    }
  }

  // Cadastro
  static Future<AuthResponseModel> cadastrar(
    String nome,
    String email,
    String senha,
    String? telefone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/cadastrar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'telefone': telefone,
        }),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(
          json.decode(response.body),
        );

        if (authResponse.success) {
          _token = authResponse.token;
          _refreshToken = authResponse.refreshToken;
          _usuario = authResponse.usuario;
        }

        return authResponse;
      } else {
        return AuthResponseModel(success: false);
      }
    } catch (e) {
      return AuthResponseModel(success: false);
    }
  }

  // Logout
  static Future<void> logout() async {
    if (_token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/Auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      } catch (e) {
        // Ignora erros no logout
      }
    }

    _token = null;
    _refreshToken = null;
    _usuario = null;
  }

  // Refresh token
  static Future<bool> refreshTokenMethod() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(
          json.decode(response.body),
        );

        if (authResponse.success) {
          _token = authResponse.token;
          _refreshToken = authResponse.refreshToken;
          return true;
        }
      }
    } catch (e) {
      // Ignora erros
    }

    return false;
  }

  // Verificar token
  static Future<bool> verificarToken() async {
    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Auth/verificar'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Obter headers com token
  static Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}
