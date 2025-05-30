class LavouraModel {
  int? id;
  int? insumoID;
  int? aplicacaoID;
  int? plantioID;
  int? colheitaID;
  double area;
  String nome;

  LavouraModel({
    this.id,
    this.insumoID,
    this.aplicacaoID,
    this.plantioID,
    this.colheitaID,
    required this.nome,
    required this.area,
  });

  factory LavouraModel.fromJson(Map<String, dynamic> map) {
    return LavouraModel(
      id: map['id'],
      insumoID: map['insumoID'],
      aplicacaoID: map['aplicacaoID'],
      plantioID: map['plantioID'],
      colheitaID: map['colheitaID'],
      nome: map['nome'],
      area: map['area'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'insumoID': insumoID,
      'aplicacaoID': aplicacaoID,
      'plantioID': aplicacaoID,
      'colhetiaID': colheitaID,
      'nome': nome,
      'area': area,
    };
  }
}
