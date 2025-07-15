class AplicacaoModel {
  int? id;
  int agrotoxicoID;
  String descricao;
  DateTime dataHora;

  AplicacaoModel({
    this.id,
    required this.agrotoxicoID,
    required this.descricao,
    required this.dataHora,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoModel(
      id: map['id'],
      agrotoxicoID: map['agrotoxicoID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'agrotoxicoID': agrotoxicoID,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
    };
  }
}
