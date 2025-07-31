class PlantioModel {
  int? id;
  int sementeID;
  int lavouraID;
  String descricao;
  DateTime dataHora;
  double areaPlantada;

  PlantioModel({
    this.id,
    required this.sementeID,
    required this. lavouraID,
    required this.descricao,
    required this.dataHora,
    required this.areaPlantada,
  });

  factory PlantioModel.fromJson(Map<String, dynamic> map) {
    return PlantioModel(
      id: map['id'],
      sementeID: map['sementeID'],
      lavouraID: map['lavouraID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
      areaPlantada: map['areaPlantada'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'sementeID': sementeID,
      'lavouraID': lavouraID,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(), 
      'areaPlantada': areaPlantada,
    };
  }
}
