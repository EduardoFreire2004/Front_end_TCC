class AgrotoxicoModel {
  int? id;
  int fornecedorID;
  int tipoID;
  String nome;
  String unidade_Medida;
  DateTime data_Cadastro;
  double qtde;
  double preco;

  AgrotoxicoModel({
    this.id,
    required this.fornecedorID,
    required this.tipoID,
    required this.nome,
    required this.unidade_Medida,
    required this.data_Cadastro,
    required this.qtde,
    required this.preco,
  });

  factory AgrotoxicoModel.fromJson(Map<String, dynamic> map) {
    return AgrotoxicoModel(
      id: map['id'],
      fornecedorID: map['fornecedorID'],
      tipoID: map['tipoID'],
      nome: map['nome'],
      unidade_Medida: map['unidade_Medida'],
      data_Cadastro: DateTime.parse(map['data_Cadastro']),
      qtde: map['qtde'].toDouble(),
      preco: map['preco'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'fornecedorID': fornecedorID,
      'tipoID': tipoID,
      'nome': nome,
      'unidade_Medida': unidade_Medida,
      'data_Cadastro': data_Cadastro.toIso8601String(),
      'qtde': qtde,
      'preco': preco,
    };
  }
}

