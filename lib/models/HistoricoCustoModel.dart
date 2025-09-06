class HistoricoCustoModel {
  final int id;
  final String tipoOperacao;
  final String descricao;
  final double custo;
  final DateTime data;
  final String? produtoNome;
  final double? quantidade;
  final String? unidadeMedida;

  HistoricoCustoModel({
    required this.id,
    required this.tipoOperacao,
    required this.descricao,
    required this.custo,
    required this.data,
    this.produtoNome,
    this.quantidade,
    this.unidadeMedida,
  });

  factory HistoricoCustoModel.fromJson(Map<String, dynamic> json) {
    return HistoricoCustoModel(
      id: json['id'],
      tipoOperacao: json['tipoOperacao'],
      descricao: json['descricao'],
      custo:
          (json['custo'] is int)
              ? (json['custo'] as int).toDouble()
              : json['custo'].toDouble(),
      data: DateTime.parse(json['data']),
      produtoNome: json['produtoNome'],
      quantidade: json['quantidade']?.toDouble(),
      unidadeMedida: json['unidadeMedida'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoOperacao': tipoOperacao,
      'descricao': descricao,
      'custo': custo,
      'data': data.toIso8601String(),
      if (produtoNome != null) 'produtoNome': produtoNome,
      if (quantidade != null) 'quantidade': quantidade,
      if (unidadeMedida != null) 'unidadeMedida': unidadeMedida,
    };
  }

  HistoricoCustoModel copyWith({
    int? id,
    String? tipoOperacao,
    String? descricao,
    double? custo,
    DateTime? data,
    String? produtoNome,
    double? quantidade,
    String? unidadeMedida,
  }) {
    return HistoricoCustoModel(
      id: id ?? this.id,
      tipoOperacao: tipoOperacao ?? this.tipoOperacao,
      descricao: descricao ?? this.descricao,
      custo: custo ?? this.custo,
      data: data ?? this.data,
      produtoNome: produtoNome ?? this.produtoNome,
      quantidade: quantidade ?? this.quantidade,
      unidadeMedida: unidadeMedida ?? this.unidadeMedida,
    );
  }

  @override
  String toString() {
    return 'HistoricoCustoModel(id: $id, tipoOperacao: $tipoOperacao, descricao: $descricao, custo: $custo, data: $data, produtoNome: $produtoNome, quantidade: $quantidade, unidadeMedida: $unidadeMedida)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoricoCustoModel &&
        other.id == id &&
        other.tipoOperacao == tipoOperacao &&
        other.descricao == descricao &&
        other.custo == custo &&
        other.data == data &&
        other.produtoNome == produtoNome &&
        other.quantidade == quantidade &&
        other.unidadeMedida == unidadeMedida;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tipoOperacao.hashCode ^
        descricao.hashCode ^
        custo.hashCode ^
        data.hashCode ^
        produtoNome.hashCode ^
        quantidade.hashCode ^
        unidadeMedida.hashCode;
  }
}
