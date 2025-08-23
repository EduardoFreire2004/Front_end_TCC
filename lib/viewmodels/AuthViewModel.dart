import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/AuthResponseModel.dart';
import '../models/UsuarioModel.dart';
import '../services/viewmodel_manager.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  bool _isAuthenticated = false;
  UsuarioModel? _usuario;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  UsuarioModel? get usuario => _usuario;

  AuthViewModel() {
    _checkAuthStatus();
    // Registrar este ViewModel no manager
    ViewModelManager().registerViewModel(this);
  }

  @override
  void clearData() {
    _isAuthenticated = false;
    _usuario = null;
    clearError();
    notifyListeners();
  }

  // Verificar status de autenticação
  Future<void> _checkAuthStatus() async {
    _isAuthenticated = AuthService.isAuthenticated;
    _usuario = AuthService.usuario;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String senha) async {
    setLoading(true);
    clearError();

    try {
      final response = await AuthService.login(email, senha);

      if (response.success) {
        _isAuthenticated = true;
        _usuario = response.usuario;
        notifyListeners();
        return true;
      } else {
        setError('Email ou senha inválidos');
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      setError('Erro ao fazer login: $e');
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Cadastro
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

      if (response.success) {
        _isAuthenticated = true;
        _usuario = response.usuario;
        notifyListeners();
        return true;
      } else {
        setError('Erro ao cadastrar usuário');
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      setError('Erro ao cadastrar: $e');
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    setLoading(true);

    try {
      await AuthService.logout();
      _isAuthenticated = false;
      _usuario = null;
      clearError();

      // Limpar todos os dados dos outros ViewModels
      ViewModelManager().clearDataExcept(this);
    } catch (e) {
      setError('Erro ao fazer logout: $e');
    } finally {
      setLoading(false);
    }
  }

  // Verificar token
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
}
