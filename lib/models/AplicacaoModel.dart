class AplicacaoModel {
  int? id;
  int agrotoxicoID;
  String descicao;
  DateTime data_Hora;

  AplicacaoModel({
    this.id,
    required this.agrotoxicoID,
    required this.descicao,
    required this.data_Hora,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoModel(
      id: map['id'],
      agrotoxicoID: map['agrotoxicoID'],
      descicao: map['descricao'],
      data_Hora: DateTime.parse(map['data_hora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'agrotoxicoID': agrotoxicoID,
      'descricao': descicao,
      'data_Hora': data_Hora.toIso8601String(),
    };
  }
}
