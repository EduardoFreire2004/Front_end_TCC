class ForneInsumoModel {
  int? id;
  String nome;
  String cnpj;
  String telefone;

  ForneInsumoModel({
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

  factory ForneInsumoModel.fromJson(Map<String, dynamic> map) {
    return ForneInsumoModel(
      id: map['id'],
      nome: map['nome'],
      cnpj: map['cnpj'],
      telefone: map['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  }
}
