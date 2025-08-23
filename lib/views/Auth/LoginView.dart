import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/AuthViewModel.dart';
import '../../viewmodels/ThemaProviderViewModel.dart';
import '../../config/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLogin = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo e título
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.agriculture,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'FGL',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Text(
                          'FREIRE GERENCIAMENTO DE LAVOURAS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Campo de nome (apenas para cadastro)
                        if (!_isLogin) ...[
                          TextFormField(
                            controller: _nomeController,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[700]!,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (!_isLogin &&
                                  (value == null || value.isEmpty)) {
                                return 'Por favor, insira seu nome';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Campo de email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.green[700]!,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu email';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor, insira um email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo de senha
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.green[700]!,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua senha';
                            }
                            if (value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Botão de ação
                        Consumer<AuthViewModel>(
                          builder: (context, authViewModel, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    authViewModel.isLoading
                                        ? null
                                        : () => _handleSubmit(authViewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child:
                                    authViewModel.isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          _isLogin ? 'Entrar' : 'Cadastrar',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Mensagem de erro
                        Consumer<AuthViewModel>(
                          builder: (context, authViewModel, child) {
                            if (authViewModel.errorMessage != null) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  authViewModel.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Alternar entre login e cadastro
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              context.read<AuthViewModel>().clearError();
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Não tem uma conta? Cadastre-se'
                                : 'Já tem uma conta? Faça login',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      final success =
          _isLogin
              ? await authViewModel.login(
                _emailController.text,
                _senhaController.text,
              )
              : await authViewModel.cadastrar(
                _nomeController.text,
                _emailController.text,
                _senhaController.text,
                null,
              );

      if (success && mounted) {
        // Limpar os campos após sucesso
        _nomeController.clear();
        _emailController.clear();
        _senhaController.clear();
        // O AuthWrapper irá redirecionar automaticamente para a tela principal
        // Não é necessário navegar manualmente
      }
    }
  }
}
