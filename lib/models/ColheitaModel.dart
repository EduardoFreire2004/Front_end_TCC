class ColheitaModel {
  int? id;
  String tipo;
  DateTime dataHora;
  String? descricao;

  ColheitaModel({
    this.id,
    required this.tipo,
    required this.dataHora,
    this.descricao,
  });

  factory ColheitaModel.fromJson(Map<String, dynamic> map) {
    return ColheitaModel(
      id: map['id'],
      tipo: map['tipo'] ?? '',
      dataHora: DateTime.parse(map['dataHora']),
      descricao: map['descricao'],
    );
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'tipo': tipo,
      'dataHora': dataHora.toIso8601String(), 
      'descricao': descricao,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'id':id,
      'tipo': tipo,
      'dataHora': dataHora.toIso8601String(), 
      'descricao': descricao,
    };
  }
}
