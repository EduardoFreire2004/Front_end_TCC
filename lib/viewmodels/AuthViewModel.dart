import '../services/auth_service.dart';
import '../models/UsuarioModel.dart';
import '../services/viewmodel_manager.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  bool _isAuthenticated = false;
  UsuarioModel? _usuario;

  bool get isAuthenticated => _isAuthenticated;
  UsuarioModel? get usuario => _usuario;

  AuthViewModel() {
    _checkAuthStatus();

    ViewModelManager().registerViewModel(this);
  }

  @override
  void clearData() {
    _isAuthenticated = false;
    _usuario = null;
    clearError();
    notifyListeners();
  }

  Future<void> _checkAuthStatus() async {
    _isAuthenticated = AuthService.isAuthenticated;
    _usuario = AuthService.usuario;
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    setLoading(true);
    clearError();

    try {
      final response = await AuthService.login(email, senha);

      if (response.success && response.hasAuthData) {
        _isAuthenticated = true;
        _usuario = response.usuario;
        notifyListeners();

        await ViewModelManager().refreshAllDataAfterLogin();

        return true;
      } else {

        if (response.message != null && response.message!.isNotEmpty) {
          setError(response.message!);
        } else if (!response.success) {
          setError('Falha na autenticação. Tente novamente.');
        } else if (!response.hasAuthData) {
          setError('Resposta inválida do servidor. Tente novamente.');
        } else {
          setError('Email ou senha incorretos');
        }

        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      String errorMessage = 'Erro ao fazer login';

      if (e.toString().contains('timeout') ||
          e.toString().contains('TimeoutException')) {
        errorMessage =
            'Tempo de resposta excedido. Verifique sua conexão e tente novamente.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        errorMessage =
            'Sem conexão com a internet. Verifique sua rede e tente novamente.';
      } else if (e.toString().contains('retry')) {
        errorMessage = 'Problema de conexão. Tentando novamente...';
      } else {
        errorMessage = 'Erro ao fazer login: $e';
      }

      setError(errorMessage);
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> cadastrar(
    String nome,
    String email,
    String senha,
    String? telefone,
  ) async {
    setLoading(true);
    clearError();

    try {
      final response = await AuthService.cadastrar(
        nome,
        email,
        senha,
        telefone,
      );

      if (response.success && response.isValid) {
        _isAuthenticated = true;
        _usuario = response.usuario;
        notifyListeners();

        await ViewModelManager().refreshAllDataAfterLogin();

        return true;
      } else {

        if (!response.isValid) {
          setError('Resposta inválida do servidor. Tente novamente.');
        } else {
          setError('Erro ao cadastrar usuário. Tente novamente.');
        }
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      String errorMessage = 'Erro ao cadastrar';

      if (e.toString().contains('timeout') ||
          e.toString().contains('TimeoutException')) {
        errorMessage =
            'Tempo de resposta excedido. O cadastro pode estar demorando mais do que o esperado.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        errorMessage =
            'Sem conexão com a internet. Verifique sua rede e tente novamente.';
      } else if (e.toString().contains('retry')) {
        errorMessage = 'Problema de conexão. Tentando novamente...';
      } else {
        errorMessage = 'Erro ao cadastrar: $e';
      }

      setError(errorMessage);
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);

    try {
      await AuthService.logout();
      _isAuthenticated = false;
      _usuario = null;
      clearError();

      ViewModelManager().clearDataExcept(this);
    } catch (e) {
      setError('Erro ao fazer logout: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verificarToken() async {
    try {
      final isValid = await AuthService.verificarToken();
      if (!isValid) {
        _isAuthenticated = false;
        _usuario = null;
        notifyListeners();
      }
      return isValid;
    } catch (e) {
      _isAuthenticated = false;
      _usuario = null;
      notifyListeners();
      return false;
    }
  }

  Future<UsuarioModel?> obterPerfil() async {
    try {
      final perfil = await AuthService.obterPerfil();
      if (perfil != null) {
        _usuario = perfil;
        notifyListeners();
      }
      return perfil;
    } catch (e) {
      setError('Erro ao obter perfil: $e');
      return null;
    }
  }

  bool get isTokenExpiringSoon {
    final expiresAt = AuthService.tokenExpiresAt;
    if (expiresAt == null) return true;

    final threshold = expiresAt.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(threshold);
  }

  Future<bool> renovarToken() async {
    try {
      final success = await AuthService.refreshTokenMethod();
      if (success) {
        _usuario = AuthService.usuario;
        notifyListeners();
      }
      return success;
    } catch (e) {
      setError('Erro ao renovar token: $e');
      return false;
    }
  }
}

