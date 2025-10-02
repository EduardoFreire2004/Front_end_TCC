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

    int? id;
    String nome = '';
    String email = '';
    String? telefone;
    String? senha;

    if (map['id'] != null) {
      final idValue = map['id'];
      if (idValue is int) {
        id = idValue;
      } else if (idValue is String) {
        id = int.tryParse(idValue);
      }

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

    final nomeValue =
        map['nome'] ?? map['Nome'] ?? map['name'] ?? map['Name'] ?? '';
    nome = nomeValue.toString().trim();

    if (nome.isEmpty) nome = '';

    final emailValue = map['email'] ?? map['Email'] ?? map['userEmail'] ?? '';
    email = emailValue.toString().trim();

    if (email.isEmpty) email = '';

    final telefoneValue =
        map['telefone'] ?? map['Telefone'] ?? map['phone'] ?? map['Phone'];
    telefone = telefoneValue?.toString().trim();

    if (telefone != null && telefone.isEmpty) telefone = null;

    final senhaValue =
        map['senha'] ?? map['Senha'] ?? map['password'] ?? map['Password'];
    senha = senhaValue?.toString().trim();

    if (senha != null && senha.isEmpty) senha = null;

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

    if (id != null) data['id'] = id;
    if (telefone != null && telefone!.isNotEmpty) data['telefone'] = telefone;
    if (senha != null && senha!.isNotEmpty) data['senha'] = senha;

    return data;
  }

  Map<String, dynamic> toJsonForRegistration() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha ?? '',
      'telefone': telefone ?? '',
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = {'nome': nome, 'email': email};

    if (telefone != null && telefone!.isNotEmpty) data['telefone'] = telefone;

    return data;
  }

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

