import 'UsuarioModel.dart';

class AuthResponseModel {
  final bool success;
  final String? token;
  final String? refreshToken;
  final UsuarioModel? usuario;
  final DateTime? expiresAt;
  final String? message; // Campo adicional para mensagens da API

  AuthResponseModel({
    required this.success,
    this.token,
    this.refreshToken,
    this.usuario,
    this.expiresAt,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> map) {
    // Tentar diferentes formatos de resposta
    bool success = false;
    String? token;
    String? refreshToken;
    UsuarioModel? usuario;
    DateTime? expiresAt;
    String? message;

    // Verificar diferentes formatos de sucesso
    if (map.containsKey('success')) {
      success = map['success'] == true;
    } else if (map.containsKey('Success')) {
      success = map['Success'] == true;
    } else if (map.containsKey('isSuccess')) {
      success = map['isSuccess'] == true;
    }

    // Verificar token
    token =
        map['token'] ??
        map['Token'] ??
        map['accessToken'] ??
        map['access_token'];

    // Verificar refresh token
    refreshToken =
        map['refreshToken'] ?? map['RefreshToken'] ?? map['refresh_token'];

    // Verificar mensagem
    message = map['message'] ?? map['Message'] ?? map['error'] ?? map['Error'];

    // Verificar expiresAt
    if (map['expiresAt'] != null) {
      try {
        final expiresAtStr = map['expiresAt'].toString();
        // Verificar se não é a data padrão inválida
        if (expiresAtStr != '0001-01-01T00:00:00' && expiresAtStr.isNotEmpty) {
          expiresAt = DateTime.parse(expiresAtStr);
        }
      } catch (e) {
        // Ignorar erros de parsing de data
      }
    } else if (map['expires_at'] != null) {
      try {
        final expiresAtStr = map['expires_at'].toString();
        if (expiresAtStr != '0001-01-01T00:00:00' && expiresAtStr.isNotEmpty) {
          expiresAt = DateTime.parse(expiresAtStr);
        }
      } catch (e) {
        // Ignorar erros de parsing de data
      }
    }

    // Verificar usuário
    if (map['usuario'] != null) {
      try {
        usuario = UsuarioModel.fromJson(map['usuario']);
      } catch (e) {
        // Ignorar erros de parsing de usuário
      }
    } else if (map['user'] != null) {
      try {
        usuario = UsuarioModel.fromJson(map['user']);
      } catch (e) {
        // Ignorar erros de parsing de usuário
      }
    } else if (map['data'] != null && map['data'] is Map) {
      try {
        usuario = UsuarioModel.fromJson(map['data']);
      } catch (e) {
        // Ignorar erros de parsing de usuário
      }
    }

    return AuthResponseModel(
      success: success,
      token: token,
      refreshToken: refreshToken,
      usuario: usuario,
      expiresAt: expiresAt,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'refreshToken': refreshToken,
      'usuario': usuario?.toJson(),
      'expiresAt': expiresAt?.toIso8601String(),
      'message': message,
    };
  }

  // Verificar se o token está expirado
  bool get isTokenExpired {
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Verificar se a resposta é válida - mais flexível
  bool get isValid {
    // Se não tem sucesso, não é válido
    if (!success) return false;

    // Se tem token, é válido (mesmo sem usuário)
    if (token != null && token!.isNotEmpty) return true;

    // Se tem usuário, é válido (mesmo sem token)
    if (usuario != null) return true;

    return false;
  }

  // Verificar se tem dados mínimos para autenticação
  bool get hasAuthData {
    return token != null && token!.isNotEmpty && token != '';
  }

  @override
  String toString() {
    return 'AuthResponseModel{success: $success, token: ${token != null ? 'presente' : 'ausente'}, refreshToken: ${refreshToken != null ? 'presente' : 'ausente'}, usuario: $usuario, expiresAt: $expiresAt, message: $message}';
  }
}
