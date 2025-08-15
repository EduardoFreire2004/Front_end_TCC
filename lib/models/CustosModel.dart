class CustoModel {
  int? id;
  int lavouraID;
  int? aplicacaoAgrotoxicoID;
  int? aplicacaoInsumoID;
  int? plantioID;
  int? colheitaID;
  double custoTotal;
  double ganhoTotal;

  CustoModel({
    this.id,
    required this.lavouraID,
    this.aplicacaoAgrotoxicoID,
    this.aplicacaoInsumoID,
    this.plantioID,
    this.colheitaID,
    required this.custoTotal,
    required this.ganhoTotal,
  });

  factory CustoModel.fromJson(Map<String, dynamic> map) {
    return CustoModel(
      id: map['id'],
      lavouraID: map['lavouraID'],
      aplicacaoAgrotoxicoID: map['aplicacaoAgrotoxicoID'],
      aplicacaoInsumoID: map['aplicacaoInsumoID'],
      plantioID: map['plantioID'],
      colheitaID: map['colheitaID'],
      custoTotal: (map['custoTotal'] as num).toDouble(),
      ganhoTotal: (map['ganhoTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lavouraID': lavouraID,
      'aplicacaoAgrotoxicoID': aplicacaoAgrotoxicoID,
      'aplicacaoInsumoID': aplicacaoInsumoID,
      'plantioID': plantioID,
      'colheitaID': colheitaID,
      'custoTotal': custoTotal,
      'ganhoTotal': ganhoTotal,
    };
  }
}
