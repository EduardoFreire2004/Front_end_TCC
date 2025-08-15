class RendimentoColheitaModel {
  final int lavouraId;
  final double rendimentoPorHectare;
  final double totalSacas;
  final double totalArea;
  final double totalReceita;

  RendimentoColheitaModel({
    required this.lavouraId,
    required this.rendimentoPorHectare,
    required this.totalSacas,
    required this.totalArea,
    required this.totalReceita,
  });

  factory RendimentoColheitaModel.fromJson(Map<String, dynamic> json) {
    return RendimentoColheitaModel(
      lavouraId: json['lavouraId'],
      rendimentoPorHectare: (json['rendimentoPorHectare'] as num).toDouble(),
      totalSacas: (json['totalSacas'] as num).toDouble(),
      totalArea: (json['totalArea'] as num).toDouble(),
      totalReceita: (json['totalReceita'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lavouraId': lavouraId,
      'rendimentoPorHectare': rendimentoPorHectare,
      'totalSacas': totalSacas,
      'totalArea': totalArea,
      'totalReceita': totalReceita,
    };
  }
}
