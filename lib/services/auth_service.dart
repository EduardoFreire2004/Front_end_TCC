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

  // Getters
  static String? get token => _token;
  static String? get refreshToken => _refreshToken;
  static UsuarioModel? get usuario => _usuario;
  static bool get isAuthenticated => _token != null && !_isTokenExpired();
  static DateTime? get tokenExpiresAt => _tokenExpiresAt;

  // Verificar se o token está expirado
  static bool _isTokenExpired() {
    if (_tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_tokenExpiresAt!);
  }

  // Verificar se o token precisa ser renovado
  static bool get _shouldRefreshToken {
    if (_tokenExpiresAt == null) return false;
    final threshold = _tokenExpiresAt!.subtract(
      ApiConfig.tokenRefreshThreshold,
    );
    return DateTime.now().isAfter(threshold);
  }

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

  // Login
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
          // Tentar extrair mensagem de erro da resposta
          String errorMessage = 'Erro no servidor';
          try {
            final errorData = json.decode(response.body);
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {
            // Se não conseguir decodificar, usar status code
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

  // Cadastro
  static Future<AuthResponseModel> cadastrar(
    String nome,
    String email,
    String senha,
    String? telefone,
  ) async {
    return await _retryRequest(() async {
      try {
        // Criar um usuário temporário para usar o método de serialização
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
          // Tentar extrair mensagem de erro da resposta
          String errorMessage = 'Erro no servidor';
          try {
            final errorData = json.decode(response.body);
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {
            // Se não conseguir decodificar, usar status code
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

  // Logout
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
        // Ignora erros no logout
      }
    }

    _clearAuthData();
  }

  // Refresh token
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
      // Ignora erros
    }

    return false;
  }

  // Verificar token
  static Future<bool> verificarToken() async {
    if (_token == null || _isTokenExpired()) return false;

    // Se o token está próximo de expirar, tentar renovar
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
        // Token inválido, tentar renovar
        return await refreshTokenMethod();
      }
    } catch (e) {
      // Se houver erro de conexão, tentar renovar o token
      return await refreshTokenMethod();
    }

    return false;
  }

  // Obter perfil do usuário
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
      // Ignora erros
    }

    return null;
  }

  // Limpar dados de autenticação
  static void _clearAuthData() {
    _token = null;
    _refreshToken = null;
    _usuario = null;
    _tokenExpiresAt = null;
  }

  // Obter headers com token
  static Map<String, String> getAuthHeaders() {
    return {
      ...ApiConfig.defaultHeaders,
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Verificar se precisa renovar o token
  static Future<bool> checkAndRefreshTokenIfNeeded() async {
    if (_shouldRefreshToken) {
      return await refreshTokenMethod();
    }
    return true;
  }
}
