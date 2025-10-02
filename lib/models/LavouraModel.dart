class LavouraModel {
  int? id;
  double area;
  String nome;
  double latitude;
  double longitude;

  LavouraModel({
    this.id,
    required this.nome,
    required this.area,
    required this.latitude,
    required this.longitude,
  });

  factory LavouraModel.fromJson(Map<String, dynamic> map) {
    return LavouraModel(
      id: map['id'],
      nome: map['nome'],
      area: map['area'].toDouble(),
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

