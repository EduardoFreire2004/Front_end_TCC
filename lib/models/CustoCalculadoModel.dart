import 'DetalheCustoModel.dart';

class CustoCalculadoModel {
  final int lavouraId;
  final String nomeLavoura;
  final double custoTotal;
  final double custoAplicacoes;
  final double custoAplicacoesInsumos;
  final double custoMovimentacoes;
  final double custoPlantios;
  final double custoColheitas;
  final DateTime dataCalculo;
  final List<DetalheCustoModel> detalhes;

  CustoCalculadoModel({
    required this.lavouraId,
    required this.nomeLavoura,
    required this.custoTotal,
    required this.custoAplicacoes,
    required this.custoAplicacoesInsumos,
    required this.custoMovimentacoes,
    required this.custoPlantios,
    required this.custoColheitas,
    required this.dataCalculo,
    required this.detalhes,
  });

  factory CustoCalculadoModel.fromJson(Map<String, dynamic> json) {
    try {
      return CustoCalculadoModel(
        lavouraId: json['lavouraId'] ?? 0,
        nomeLavoura: json['nomeLavoura'] ?? '',
        custoTotal: _parseDouble(json['custoTotal']),
        custoAplicacoes: _parseDouble(json['custoAplicacoes']),
        custoAplicacoesInsumos: _parseDouble(json['custoAplicacoesInsumos']),
        custoMovimentacoes: _parseDouble(json['custoMovimentacoes']),
        custoPlantios: _parseDouble(json['custoPlantios']),
        custoColheitas: _parseDouble(json['custoColheitas']),
        dataCalculo:
            DateTime.tryParse(json['dataCalculo'] ?? '') ?? DateTime.now(),
        detalhes:
            (json['detalhes'] as List?)
                ?.map((d) => DetalheCustoModel.fromJson(d))
                .toList() ??
            [],
      );
    } catch (e) {
      throw Exception('Erro ao criar CustoCalculadoModel: $e');
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'lavouraId': lavouraId,
      'nomeLavoura': nomeLavoura,
      'custoTotal': custoTotal,
      'custoAplicacoes': custoAplicacoes,
      'custoAplicacoesInsumos': custoAplicacoesInsumos,
      'custoMovimentacoes': custoMovimentacoes,
      'custoPlantios': custoPlantios,
      'custoColheitas': custoColheitas,
      'dataCalculo': dataCalculo.toIso8601String(),
      'detalhes': detalhes.map((d) => d.toJson()).toList(),
    };
  }

  CustoCalculadoModel copyWith({
    int? lavouraId,
    String? nomeLavoura,
    double? custoTotal,
    double? custoAplicacoes,
    double? custoAplicacoesInsumos,
    double? custoMovimentacoes,
    double? custoPlantios,
    double? custoColheitas,
    DateTime? dataCalculo,
    List<DetalheCustoModel>? detalhes,
  }) {
    return CustoCalculadoModel(
      lavouraId: lavouraId ?? this.lavouraId,
      nomeLavoura: nomeLavoura ?? this.nomeLavoura,
      custoTotal: custoTotal ?? this.custoTotal,
      custoAplicacoes: custoAplicacoes ?? this.custoAplicacoes,
      custoAplicacoesInsumos:
          custoAplicacoesInsumos ?? this.custoAplicacoesInsumos,
      custoMovimentacoes: custoMovimentacoes ?? this.custoMovimentacoes,
      custoPlantios: custoPlantios ?? this.custoPlantios,
      custoColheitas: custoColheitas ?? this.custoColheitas,
      dataCalculo: dataCalculo ?? this.dataCalculo,
      detalhes: detalhes ?? this.detalhes,
    );
  }

  @override
  String toString() {
    return 'CustoCalculadoModel(lavouraId: $lavouraId, nomeLavoura: $nomeLavoura, custoTotal: $custoTotal, custoAplicacoes: $custoAplicacoes, custoAplicacoesInsumos: $custoAplicacoesInsumos, custoMovimentacoes: $custoMovimentacoes, custoPlantios: $custoPlantios, custoColheitas: $custoColheitas, dataCalculo: $dataCalculo, detalhes: ${detalhes.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustoCalculadoModel &&
        other.lavouraId == lavouraId &&
        other.nomeLavoura == nomeLavoura &&
        other.custoTotal == custoTotal &&
        other.custoAplicacoes == custoAplicacoes &&
        other.custoAplicacoesInsumos == custoAplicacoesInsumos &&
        other.custoMovimentacoes == custoMovimentacoes &&
        other.custoPlantios == custoPlantios &&
        other.custoColheitas == custoColheitas &&
        other.dataCalculo == dataCalculo &&
        other.detalhes == detalhes;
  }

  @override
  int get hashCode {
    return lavouraId.hashCode ^
        nomeLavoura.hashCode ^
        custoTotal.hashCode ^
        custoAplicacoes.hashCode ^
        custoAplicacoesInsumos.hashCode ^
        custoMovimentacoes.hashCode ^
        custoPlantios.hashCode ^
        custoColheitas.hashCode ^
        dataCalculo.hashCode ^
        detalhes.hashCode;
  }
}


