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

    bool success = false;
    String? token;
    String? refreshToken;
    UsuarioModel? usuario;
    DateTime? expiresAt;
    String? message;

    if (map.containsKey('success')) {
      success = map['success'] == true;
    } else if (map.containsKey('Success')) {
      success = map['Success'] == true;
    } else if (map.containsKey('isSuccess')) {
      success = map['isSuccess'] == true;
    }

    token =
        map['token'] ??
        map['Token'] ??
        map['accessToken'] ??
        map['access_token'];

    refreshToken =
        map['refreshToken'] ?? map['RefreshToken'] ?? map['refresh_token'];

    message = map['message'] ?? map['Message'] ?? map['error'] ?? map['Error'];

    if (map['expiresAt'] != null) {
      try {
        final expiresAtStr = map['expiresAt'].toString();

        if (expiresAtStr != '0001-01-01T00:00:00' && expiresAtStr.isNotEmpty) {
          expiresAt = DateTime.parse(expiresAtStr);
        }
      } catch (e) {

      }
    } else if (map['expires_at'] != null) {
      try {
        final expiresAtStr = map['expires_at'].toString();
        if (expiresAtStr != '0001-01-01T00:00:00' && expiresAtStr.isNotEmpty) {
          expiresAt = DateTime.parse(expiresAtStr);
        }
      } catch (e) {

      }
    }

    if (map['usuario'] != null) {
      try {
        usuario = UsuarioModel.fromJson(map['usuario']);
      } catch (e) {

      }
    } else if (map['user'] != null) {
      try {
        usuario = UsuarioModel.fromJson(map['user']);
      } catch (e) {

      }
    } else if (map['data'] != null && map['data'] is Map) {
      try {
        usuario = UsuarioModel.fromJson(map['data']);
      } catch (e) {

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

  bool get isTokenExpired {
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValid {

    if (!success) return false;

    if (token != null && token!.isNotEmpty) return true;

    if (usuario != null) return true;

    return false;
  }

  bool get hasAuthData {
    return token != null && token!.isNotEmpty && token != '';
  }

  @override
  String toString() {
    return 'AuthResponseModel{success: $success, token: ${token != null ? 'presente' : 'ausente'}, refreshToken: ${refreshToken != null ? 'presente' : 'ausente'}, usuario: $usuario, expiresAt: $expiresAt, message: $message}';
  }
}

