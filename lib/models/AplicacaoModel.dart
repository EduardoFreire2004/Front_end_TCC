class AplicacaoModel {
  int? id;
  int agrotoxicoID;
  int lavouraID;
  String descricao;
  DateTime dataHora;
  double qtde;

  AplicacaoModel({
    this.id,
    required this.agrotoxicoID,
    required this.lavouraID,
    required this.descricao,
    required this.dataHora,
    required this.qtde,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoModel(
      id: map['id'],
      agrotoxicoID: map['agrotoxicoID'],
      lavouraID: map['lavouraID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
      qtde: map['qtde'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'agrotoxicoID': agrotoxicoID,
      'lavouraID': lavouraID,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'qtde': qtde,
    };
  }
}
