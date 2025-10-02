class ApiConfig {
  static const String baseUrl =
      'http://localhost:5209/api'; // Para web/desktop (funcionando)
      //'https://unenticed-voncile-nondigestibly.ngrok-free.dev/api'; // Para web/desktop (funcionando)
  static const String authBase = '/auth';
  static const String loginEndpoint = '$authBase/login';
  static const String registerEndpoint = '$authBase/cadastrar';
  static const String refreshEndpoint = '$authBase/refresh';
  static const String logoutEndpoint = '$authBase/logout';
  static const String verifyEndpoint = '$authBase/verificar';
  static const String profileEndpoint = '$authBase/perfil';

  static const Duration requestTimeout = Duration(seconds: 60);

  static const Duration registrationTimeout = Duration(seconds: 90);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Connection': 'keep-alive',
  };

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static const Duration tokenRefreshThreshold = Duration(
    minutes: 5,
  ); // Renovar token 5 min antes de expirar
}
