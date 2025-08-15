class MovimentacaoEstoqueModel {
  int? id;
  int? agrotoxicoID;
  int? insumoID;
  int? sementeID;
  int lavouraID;
  double qtde;
  DateTime dataHora;
  int movimentacao;
  String descricao;

  MovimentacaoEstoqueModel({
    this.id,
    this.agrotoxicoID,
    this.insumoID,
    this.sementeID,
    required this.descricao,
    required this.lavouraID,
    required this.qtde,
    required this.dataHora,
    required this.movimentacao,
  });

  factory MovimentacaoEstoqueModel.fromJson(Map<String, dynamic> json) {
    return MovimentacaoEstoqueModel(
      id: json['id'],
      agrotoxicoID: json['agrotoxicoID'],
      insumoID: json['insumoID'],
      sementeID: json['sementeID'],
      lavouraID: json['lavouraID'],
      qtde: json['qtde'].toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
      movimentacao: json['movimentacao'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'agrotoxicoID': agrotoxicoID ?? 0,
    'insumoID': insumoID ?? 0,
    'sementeID': sementeID ?? 0,
    'lavouraID': lavouraID,
    'qtde': qtde,
    'dataHora': dataHora.toIso8601String(),
    'movimentacao': movimentacao,
    'descricao': descricao,
  };
}
