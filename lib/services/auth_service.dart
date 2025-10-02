import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/AuthResponseModel.dart';
import '../models/UsuarioModel.dart';
import '../config/api_config.dart';

class AuthService {
  static String? _token;
  static String? _refreshToken;
  static UsuarioModel? _usuario;
  static DateTime? _tokenExpiresAt;

  static String? get token => _token;
  static String? get refreshToken => _refreshToken;
  static UsuarioModel? get usuario => _usuario;
  static bool get isAuthenticated => _token != null && !_isTokenExpired();
  static DateTime? get tokenExpiresAt => _tokenExpiresAt;

  static bool _isTokenExpired() {
    if (_tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_tokenExpiresAt!);
  }

  static bool get _shouldRefreshToken {
    if (_tokenExpiresAt == null) return false;
    final threshold = _tokenExpiresAt!.subtract(
      ApiConfig.tokenRefreshThreshold,
    );
    return DateTime.now().isAfter(threshold);
  }

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

        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    throw Exception('Número máximo de tentativas excedido');
  }

  static Future<AuthResponseModel> login(String email, String senha) async {
    return await _retryRequest(() async {
      try {
        final response = await http
            .post(
              Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}'),
              headers: ApiConfig.defaultHeaders,
              body: json.encode({'email': email, 'senha': senha}),
            )
            .timeout(ApiConfig.requestTimeout);

        if (response.statusCode == 200) {
          final responseBody = response.body;
          Map<String, dynamic> jsonData;

          try {
            jsonData = json.decode(responseBody);
          } catch (e) {
            return AuthResponseModel(
              success: false,
              usuario: null,
              token: null,
              refreshToken: null,
            );
          }

          final authResponse = AuthResponseModel.fromJson(jsonData);

          if (authResponse.success && authResponse.hasAuthData) {
            _token = authResponse.token;
            _refreshToken = authResponse.refreshToken;
            _usuario = authResponse.usuario;
            _tokenExpiresAt = authResponse.expiresAt;
          }

          return authResponse;
        } else {

          String errorMessage = 'Erro no servidor';
          try {
            final errorData = json.decode(response.body);
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {

            switch (response.statusCode) {
              case 400:
                errorMessage = 'Dados inválidos';
                break;
              case 401:
                errorMessage = 'Email ou senha incorretos';
                break;
              case 404:
                errorMessage = 'Serviço não encontrado';
                break;
              case 500:
                errorMessage = 'Erro interno do servidor';
                break;
              default:
                errorMessage = 'Erro ${response.statusCode}';
            }
          }

          return AuthResponseModel(
            success: false,
            usuario: null,
            token: null,
            refreshToken: null,
          );
        }
      } on http.ClientException {
        return AuthResponseModel(
          success: false,
          usuario: null,
          token: null,
          refreshToken: null,
        );
      } catch (e) {
        return AuthResponseModel(
          success: false,
          usuario: null,
          token: null,
          refreshToken: null,
        );
      }
    }, ApiConfig.maxRetries);
  }

  static Future<AuthResponseModel> cadastrar(
    String nome,
    String email,
    String senha,
    String? telefone,
  ) async {
    return await _retryRequest(() async {
      try {

        final usuario = UsuarioModel(
          nome: nome,
          email: email,
          telefone: telefone,
          senha: senha,
        );

        final response = await http
            .post(
              Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}'),
              headers: ApiConfig.defaultHeaders,
              body: json.encode(usuario.toJsonForRegistration()),
            )
            .timeout(
              ApiConfig.registrationTimeout,
            ); // Timeout específico para cadastro

        if (response.statusCode == 200 || response.statusCode == 201) {
          final authResponse = AuthResponseModel.fromJson(
            json.decode(response.body),
          );

          if (authResponse.success && authResponse.isValid) {
            _token = authResponse.token;
            _refreshToken = authResponse.refreshToken;
            _usuario = authResponse.usuario;
            _tokenExpiresAt = authResponse.expiresAt;
          }

          return authResponse;
        } else {

          String errorMessage = 'Erro no servidor';
          try {
            final errorData = json.decode(response.body);
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {

            switch (response.statusCode) {
              case 400:
                errorMessage = 'Dados inválidos para cadastro';
                break;
              case 409:
                errorMessage = 'Email já cadastrado';
                break;
              case 500:
                errorMessage = 'Erro interno do servidor';
                break;
              default:
                errorMessage = 'Erro ${response.statusCode}';
            }
          }

          return AuthResponseModel(
            success: false,
            usuario: null,
            token: null,
            refreshToken: null,
          );
        }
      } on http.ClientException {
        return AuthResponseModel(
          success: false,
          usuario: null,
          token: null,
          refreshToken: null,
        );
      } catch (e) {
        return AuthResponseModel(
          success: false,
          usuario: null,
          token: null,
          refreshToken: null,
        );
      }
    }, ApiConfig.maxRetries);
  }

  static Future<void> logout() async {
    if (_token != null) {
      try {
        await http
            .post(
              Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logoutEndpoint}'),
              headers: {
                ...ApiConfig.defaultHeaders,
                'Authorization': 'Bearer $_token',
              },
            )
            .timeout(ApiConfig.requestTimeout);
      } catch (e) {

      }
    }

    _clearAuthData();
  }

  static Future<bool> refreshTokenMethod() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshEndpoint}'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode({'refreshToken': _refreshToken}),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(
          json.decode(response.body),
        );

        if (authResponse.success && authResponse.isValid) {
          _token = authResponse.token;
          _refreshToken = authResponse.refreshToken;
          _tokenExpiresAt = authResponse.expiresAt;
          return true;
        }
      }
    } catch (e) {

    }

    return false;
  }

  static Future<bool> verificarToken() async {
    if (_token == null || _isTokenExpired()) return false;

    if (_shouldRefreshToken) {
      final refreshed = await refreshTokenMethod();
      if (refreshed) return true;
    }

    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifyEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $_token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {

        return await refreshTokenMethod();
      }
    } catch (e) {

      return await refreshTokenMethod();
    }

    return false;
  }

  static Future<UsuarioModel?> obterPerfil() async {
    if (_token == null || _isTokenExpired()) return null;

    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profileEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $_token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return UsuarioModel.fromJson(userData);
      }
    } catch (e) {

    }

    return null;
  }

  static void _clearAuthData() {
    _token = null;
    _refreshToken = null;
    _usuario = null;
    _tokenExpiresAt = null;
  }

  static Map<String, String> getAuthHeaders() {
    return {
      ...ApiConfig.defaultHeaders,
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  static Future<bool> checkAndRefreshTokenIfNeeded() async {
    if (_shouldRefreshToken) {
      return await refreshTokenMethod();
    }
    return true;
  }
}

