class ForneSementeModel {
  int? id;
  String nome;
  String cnpj;
  String telefone;

  ForneSementeModel({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  }

  factory ForneSementeModel.fromJson(Map<String, dynamic> map) {
    return ForneSementeModel(
      id: map['id'],
      nome: map['nome'],
      cnpj: map['cnpj'],
      telefone: map['telefone'],
    );
  }

   Map<String, dynamic> toJsonForCreate() {
    return {
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  }
}
