class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final String? telefone;
  final String?
  senha; // Campo opcional para não enviar senha em todas as respostas

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.senha,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> map) {
    // Tentar diferentes formatos de campos
    int? id;
    String nome = '';
    String email = '';
    String? telefone;
    String? senha;

    // Verificar ID
    if (map['id'] != null) {
      final idValue = map['id'];
      if (idValue is int) {
        id = idValue;
      } else if (idValue is String) {
        id = int.tryParse(idValue);
      }
      // Ignorar ID 0 (valor padrão da API)
      if (id == 0) id = null;
    } else if (map['Id'] != null) {
      final idValue = map['Id'];
      if (idValue is int) {
        id = idValue;
      } else if (idValue is String) {
        id = int.tryParse(idValue);
      }
      if (id == 0) id = null;
    } else if (map['userId'] != null) {
      final idValue = map['userId'];
      if (idValue is int) {
        id = idValue;
      } else if (idValue is String) {
        id = int.tryParse(idValue);
      }
      if (id == 0) id = null;
    }

    // Verificar nome
    final nomeValue =
        map['nome'] ?? map['Nome'] ?? map['name'] ?? map['Name'] ?? '';
    nome = nomeValue.toString().trim();
    // Ignorar nomes vazios
    if (nome.isEmpty) nome = '';

    // Verificar email
    final emailValue = map['email'] ?? map['Email'] ?? map['userEmail'] ?? '';
    email = emailValue.toString().trim();
    // Ignorar emails vazios
    if (email.isEmpty) email = '';

    // Verificar telefone
    final telefoneValue =
        map['telefone'] ?? map['Telefone'] ?? map['phone'] ?? map['Phone'];
    telefone = telefoneValue?.toString().trim();
    // Ignorar telefones vazios
    if (telefone != null && telefone!.isEmpty) telefone = null;

    // Verificar senha
    final senhaValue =
        map['senha'] ?? map['Senha'] ?? map['password'] ?? map['Password'];
    senha = senhaValue?.toString().trim();
    // Ignorar senhas vazias
    if (senha != null && senha!.isEmpty) senha = null;

    return UsuarioModel(
      id: id,
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'nome': nome, 'email': email};

    // Só incluir campos que não são null
    if (id != null) data['id'] = id;
    if (telefone != null && telefone!.isNotEmpty) data['telefone'] = telefone;
    if (senha != null && senha!.isNotEmpty) data['senha'] = senha;

    return data;
  }

  // Método para criar um usuário para cadastro
  Map<String, dynamic> toJsonForRegistration() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha ?? '',
      'telefone': telefone ?? '',
    };
  }

  // Método para criar um usuário para atualização
  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = {'nome': nome, 'email': email};

    if (telefone != null && telefone!.isNotEmpty) data['telefone'] = telefone;

    return data;
  }

  // Validações
  bool get isValid {
    return nome.isNotEmpty && email.isNotEmpty && email.contains('@');
  }

  String? validate() {
    if (nome.trim().isEmpty) return 'Nome é obrigatório';
    if (email.trim().isEmpty) return 'Email é obrigatório';
    if (!email.contains('@')) return 'Email inválido';
    return null;
  }

  @override
  String toString() {
    return 'UsuarioModel{id: $id, nome: $nome, email: $email, telefone: $telefone}';
  }

  // Copiar com modificações
  UsuarioModel copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      senha: senha ?? this.senha,
    );
  }
}
