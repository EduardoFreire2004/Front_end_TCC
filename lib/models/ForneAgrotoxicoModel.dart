class ForneAgrotoxicoModel {
  int? id;
  String nome;
  String cnpj;
  String telefone;

  ForneAgrotoxicoModel({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
  });

  factory ForneAgrotoxicoModel.fromJson(Map<String, dynamic> map) {
    return ForneAgrotoxicoModel(
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
