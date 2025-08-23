import 'UsuarioModel.dart';

class AuthResponseModel {
  bool success;
  String? token;
  String? refreshToken;
  UsuarioModel? usuario;
  String? expiresAt;

  AuthResponseModel({
    required this.success,
    this.token,
    this.refreshToken,
    this.usuario,
    this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> map) {
    return AuthResponseModel(
      success: map['success'] ?? false,
      token: map['token'],
      refreshToken: map['refreshToken'],
      usuario:
          map['usuario'] != null ? UsuarioModel.fromJson(map['usuario']) : null,
      expiresAt: map['expiresAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'refreshToken': refreshToken,
      'usuario': usuario?.toJson(),
      'expiresAt': expiresAt,
    };
  }
}
