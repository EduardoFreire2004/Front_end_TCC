class FornecedoresModel {
  int? id;
  String nome;
  String cnpj;
  String telefone;

  FornecedoresModel({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
  });

  factory FornecedoresModel.fromJson(Map<String, dynamic> map) {
    return FornecedoresModel(
      id: map['id'],
      nome: map['nome'],
      cnpj: map['cnpj'],
      telefone: map['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  } 
}
