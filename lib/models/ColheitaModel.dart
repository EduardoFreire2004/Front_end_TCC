class ColheitaModel {
  int? id;
  int lavouraID;
  String tipo;
  DateTime dataHora;
  String? descricao;
  double quantidadeSacas;
  double areaHectares;
  String cooperativaDestino;
  double precoPorSaca;

  ColheitaModel({
    this.id,
    required this.lavouraID,
    required this.tipo,
    required this.dataHora,
    this.descricao,
    required this.quantidadeSacas,
    required this.areaHectares,
    required this.cooperativaDestino,
    required this.precoPorSaca,
  });

  factory ColheitaModel.fromJson(Map<String, dynamic> map) {
    return ColheitaModel(
      id: map['id'],
      lavouraID: map['lavouraID'],
      tipo: map['tipo'] ?? '',
      dataHora: DateTime.parse(map['dataHora']),
      descricao: map['descricao'],
      quantidadeSacas: (map['quantidadeSacas'] as num).toDouble(),
      areaHectares: (map['areaHectares'] as num).toDouble(),
      cooperativaDestino: map['cooperativaDestino'] ?? '',
      precoPorSaca: (map['precoPorSaca'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'lavouraID': lavouraID,
      'tipo': tipo,
      'dataHora': dataHora.toIso8601String(),
      'descricao': descricao,
      'quantidadeSacas': quantidadeSacas,
      'areaHectares': areaHectares,
      'cooperativaDestino': cooperativaDestino,
      'precoPorSaca': precoPorSaca,
    };
  }
}

