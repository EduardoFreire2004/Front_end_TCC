class ApiConfig {
  // URL base da API - altere conforme necessário
  static const String baseUrl =
      'http://localhost:5209/api'; // Para web/desktop (funcionando)
  // static const String baseUrl = 'http://10.0.2.2:5209/api'; // Para emulador Android
  // static const String baseUrl = 'http://192.168.1.100:5209/api'; // Para dispositivo físico (substitua pelo IP correto)

  // Endpoints de autenticação
  static const String authBase = '/auth';
  static const String loginEndpoint = '$authBase/login';
  static const String registerEndpoint = '$authBase/cadastrar';
  static const String refreshEndpoint = '$authBase/refresh';
  static const String logoutEndpoint = '$authBase/logout';
  static const String verifyEndpoint = '$authBase/verificar';
  static const String profileEndpoint = '$authBase/perfil';

  // Endpoints da nova API de relatórios JSON
  static const String relatoriosBase = '/api/relatorios';

  // Endpoints específicos para cada tipo de relatório
  static const String relatorioFornecedoresEndpoint =
      '$relatoriosBase/fornecedores';
  static const String relatorioAplicacaoEndpoint = '$relatoriosBase/aplicacao';
  static const String relatorioAplicacaoInsumoEndpoint =
      '$relatoriosBase/aplicacao-insumo';
  static const String relatorioSementeEndpoint = '$relatoriosBase/semente';
  static const String relatorioInsumoEndpoint = '$relatoriosBase/insumo';
  static const String relatorioAgrotoxicoEndpoint =
      '$relatoriosBase/agrotoxico';
  static const String relatorioColheitaEndpoint = '$relatoriosBase/colheita';
  static const String relatorioMovimentacaoEstoqueEndpoint =
      '$relatoriosBase/movimentacao-estoque';
  static const String relatorioPlantioEndpoint = '$relatoriosBase/plantio';

  // Timeout para requisições - aumentado para evitar problemas de conexão
  static const Duration requestTimeout = Duration(seconds: 60);

  // Timeout para operações de cadastro (que podem ser mais lentas)
  static const Duration registrationTimeout = Duration(seconds: 90);

  // Headers padrão
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Connection': 'keep-alive',
  };

  // Configurações de retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Configurações JWT
  static const Duration tokenRefreshThreshold = Duration(
    minutes: 5,
  ); // Renovar token 5 min antes de expirar
}
