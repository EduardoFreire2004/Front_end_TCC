class UsuarioModel {
  int? id;
  String nome;
  String email;
  String? telefone;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    this.telefone,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id ?? 0, 'nome': nome, 'email': email, 'telefone': telefone};
  }
}
