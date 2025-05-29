class InsumoModel {
  int? id;
  int categoriaID;
  int fornecedorID;
  String nome;
  String unidade_Medida;
  DateTime data_Cadastro;
  double qtde;

  InsumoModel({
    this.id,
    required this.categoriaID,
    required this.fornecedorID,
    required this.nome,
    required this.unidade_Medida,
    required this.data_Cadastro,
    required this.qtde,
  });

  factory InsumoModel.fromJson(Map<String, dynamic> map) {
    return InsumoModel(
      id: map['id'],
      categoriaID: map['categoriaInsumoID'],
      fornecedorID: map['fornecedorInsumoID'],
      nome: map['nome'],
      unidade_Medida: map['unidade_Medida'],
      data_Cadastro: DateTime.parse(map['data_Cadastro']),
      qtde: map['qtde'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'categoriaInsumoID': categoriaID,
      'fornecedorInsumoID': fornecedorID,
      'nome': nome,
      'unidade_Medida': unidade_Medida,
      'data_Cadastro': data_Cadastro.toIso8601String(),
      'qtde': qtde,       
    };
  }

}
