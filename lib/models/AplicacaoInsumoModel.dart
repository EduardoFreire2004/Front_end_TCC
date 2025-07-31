class AplicacaoInsumoModel {
  int? id;
  int insumoID;
  int lavouraID;
  String descricao;
  DateTime dataHora;

  AplicacaoInsumoModel({
    this.id,
    required this.insumoID,
    required this.lavouraID,
    required this.descricao,
    required this.dataHora,
  });

  factory AplicacaoInsumoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoInsumoModel(
      id: map['id'],
      insumoID: map['insumoID'],
      lavouraID: map['lavouraID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'insumoID': insumoID,
      'lavouraID': lavouraID,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
    };
  }
}
