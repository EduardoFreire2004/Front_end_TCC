class ResumoCustosModel {
  final int lavouraId;
  final String nomeLavoura;
  final DateTime dataInicio;
  final DateTime dataFim;
  final double custoTotal;
  final double custoAplicacoes;
  final double custoAplicacoesInsumos;
  final double custoMovimentacoes;
  final double custoPlantios;
  final double custoColheitas;
  final int totalAplicacoes;
  final int totalAplicacoesInsumos;
  final int totalMovimentacoes;
  final int totalPlantios;
  final int totalColheitas;

  ResumoCustosModel({
    required this.lavouraId,
    required this.nomeLavoura,
    required this.dataInicio,
    required this.dataFim,
    required this.custoTotal,
    required this.custoAplicacoes,
    required this.custoAplicacoesInsumos,
    required this.custoMovimentacoes,
    required this.custoPlantios,
    required this.custoColheitas,
    required this.totalAplicacoes,
    required this.totalAplicacoesInsumos,
    required this.totalMovimentacoes,
    required this.totalPlantios,
    required this.totalColheitas,
  });

  factory ResumoCustosModel.fromJson(Map<String, dynamic> json) {
    return ResumoCustosModel(
      lavouraId: json['lavouraId'],
      nomeLavoura: json['nomeLavoura'],
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: DateTime.parse(json['dataFim']),
      custoTotal:
          (json['custoTotal'] is int)
              ? (json['custoTotal'] as int).toDouble()
              : json['custoTotal'].toDouble(),
      custoAplicacoes:
          (json['custoAplicacoes'] is int)
              ? (json['custoAplicacoes'] as int).toDouble()
              : json['custoAplicacoes'].toDouble(),
      custoAplicacoesInsumos:
          (json['custoAplicacoesInsumos'] is int)
              ? (json['custoAplicacoesInsumos'] as int).toDouble()
              : json['custoAplicacoesInsumos'].toDouble(),
      custoMovimentacoes:
          (json['custoMovimentacoes'] is int)
              ? (json['custoMovimentacoes'] as int).toDouble()
              : json['custoMovimentacoes'].toDouble(),
      custoPlantios:
          (json['custoPlantios'] is int)
              ? (json['custoPlantios'] as int).toDouble()
              : json['custoPlantios'].toDouble(),
      custoColheitas:
          (json['custoColheitas'] is int)
              ? (json['custoColheitas'] as int).toDouble()
              : json['custoColheitas'].toDouble(),
      totalAplicacoes: json['totalAplicacoes'],
      totalAplicacoesInsumos: json['totalAplicacoesInsumos'],
      totalMovimentacoes: json['totalMovimentacoes'],
      totalPlantios: json['totalPlantios'],
      totalColheitas: json['totalColheitas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lavouraId': lavouraId,
      'nomeLavoura': nomeLavoura,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'custoTotal': custoTotal,
      'custoAplicacoes': custoAplicacoes,
      'custoAplicacoesInsumos': custoAplicacoesInsumos,
      'custoMovimentacoes': custoMovimentacoes,
      'custoPlantios': custoPlantios,
      'custoColheitas': custoColheitas,
      'totalAplicacoes': totalAplicacoes,
      'totalAplicacoesInsumos': totalAplicacoesInsumos,
      'totalMovimentacoes': totalMovimentacoes,
      'totalPlantios': totalPlantios,
      'totalColheitas': totalColheitas,
    };
  }

  ResumoCustosModel copyWith({
    int? lavouraId,
    String? nomeLavoura,
    DateTime? dataInicio,
    DateTime? dataFim,
    double? custoTotal,
    double? custoAplicacoes,
    double? custoAplicacoesInsumos,
    double? custoMovimentacoes,
    double? custoPlantios,
    double? custoColheitas,
    int? totalAplicacoes,
    int? totalAplicacoesInsumos,
    int? totalMovimentacoes,
    int? totalPlantios,
    int? totalColheitas,
  }) {
    return ResumoCustosModel(
      lavouraId: lavouraId ?? this.lavouraId,
      nomeLavoura: nomeLavoura ?? this.nomeLavoura,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      custoTotal: custoTotal ?? this.custoTotal,
      custoAplicacoes: custoAplicacoes ?? this.custoAplicacoes,
      custoAplicacoesInsumos:
          custoAplicacoesInsumos ?? this.custoAplicacoesInsumos,
      custoMovimentacoes: custoMovimentacoes ?? this.custoMovimentacoes,
      custoPlantios: custoPlantios ?? this.custoPlantios,
      custoColheitas: custoColheitas ?? this.custoColheitas,
      totalAplicacoes: totalAplicacoes ?? this.totalAplicacoes,
      totalAplicacoesInsumos:
          totalAplicacoesInsumos ?? this.totalAplicacoesInsumos,
      totalMovimentacoes: totalMovimentacoes ?? this.totalMovimentacoes,
      totalPlantios: totalPlantios ?? this.totalPlantios,
      totalColheitas: totalColheitas ?? this.totalColheitas,
    );
  }

  @override
  String toString() {
    return 'ResumoCustosModel(lavouraId: $lavouraId, nomeLavoura: $nomeLavoura, dataInicio: $dataInicio, dataFim: $dataFim, custoTotal: $custoTotal, custoAplicacoes: $custoAplicacoes, custoAplicacoesInsumos: $custoAplicacoesInsumos, custoMovimentacoes: $custoMovimentacoes, custoPlantios: $custoPlantios, custoColheitas: $custoColheitas, totalAplicacoes: $totalAplicacoes, totalAplicacoesInsumos: $totalAplicacoesInsumos, totalMovimentacoes: $totalMovimentacoes, totalPlantios: $totalPlantios, totalColheitas: $totalColheitas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResumoCustosModel &&
        other.lavouraId == lavouraId &&
        other.nomeLavoura == nomeLavoura &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim &&
        other.custoTotal == custoTotal &&
        other.custoAplicacoes == custoAplicacoes &&
        other.custoAplicacoesInsumos == custoAplicacoesInsumos &&
        other.custoMovimentacoes == custoMovimentacoes &&
        other.custoPlantios == custoPlantios &&
        other.custoColheitas == custoColheitas &&
        other.totalAplicacoes == totalAplicacoes &&
        other.totalAplicacoesInsumos == totalAplicacoesInsumos &&
        other.totalMovimentacoes == totalMovimentacoes &&
        other.totalPlantios == totalPlantios &&
        other.totalColheitas == totalColheitas;
  }

  @override
  int get hashCode {
    return lavouraId.hashCode ^
        nomeLavoura.hashCode ^
        dataInicio.hashCode ^
        dataFim.hashCode ^
        custoTotal.hashCode ^
        custoAplicacoes.hashCode ^
        custoAplicacoesInsumos.hashCode ^
        custoMovimentacoes.hashCode ^
        custoPlantios.hashCode ^
        custoColheitas.hashCode ^
        totalAplicacoes.hashCode ^
        totalAplicacoesInsumos.hashCode ^
        totalMovimentacoes.hashCode ^
        totalPlantios.hashCode ^
        totalColheitas.hashCode;
  }
}
