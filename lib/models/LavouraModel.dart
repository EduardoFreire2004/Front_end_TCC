class LavouraModel {
  int? id;
  double area;
  String nome;

  LavouraModel({
    this.id,
    required this.nome,
    required this.area,
  });

  factory LavouraModel.fromJson(Map<String, dynamic> map) {
    return LavouraModel(
      id: map['id'],
      nome: map['nome'],
      area: map['area'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'area': area,
    };
  }
}

