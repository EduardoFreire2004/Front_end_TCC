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

  factory ForneInsumoModel.fromJson(Map<String, dynamic> map) {
    return ForneInsumoModel(
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
      'id':id,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
    };
  }
}
