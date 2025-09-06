class DetalheCustoModel {
  final String categoria;
  final String descricao;
  final double custo;
  final DateTime data;
  final String? produtoNome;
  final double? quantidade;
  final String? unidadeMedida;

  DetalheCustoModel({
    required this.categoria,
    required this.descricao,
    required this.custo,
    required this.data,
    this.produtoNome,
    this.quantidade,
    this.unidadeMedida,
  });

  factory DetalheCustoModel.fromJson(Map<String, dynamic> json) {
    try {
      return DetalheCustoModel(
        categoria: json['categoria'] ?? '',
        descricao: json['descricao'] ?? '',
        custo: _parseDouble(json['custo']),
        data: DateTime.tryParse(json['data'] ?? '') ?? DateTime.now(),
        produtoNome: json['produtoNome'],
        quantidade: _parseDouble(json['quantidade']),
        unidadeMedida: json['unidadeMedida'],
      );
    } catch (e) {
      throw Exception('Erro ao criar DetalheCustoModel: $e');
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
      'categoria': categoria,
      'descricao': descricao,
      'custo': custo,
      'data': data.toIso8601String(),
      if (produtoNome != null) 'produtoNome': produtoNome,
      if (quantidade != null) 'quantidade': quantidade,
      if (unidadeMedida != null) 'unidadeMedida': unidadeMedida,
    };
  }

  DetalheCustoModel copyWith({
    String? categoria,
    String? descricao,
    double? custo,
    DateTime? data,
    String? produtoNome,
    double? quantidade,
    String? unidadeMedida,
  }) {
    return DetalheCustoModel(
      categoria: categoria ?? this.categoria,
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
    return 'DetalheCustoModel(categoria: $categoria, descricao: $descricao, custo: $custo, data: $data, produtoNome: $produtoNome, quantidade: $quantidade, unidadeMedida: $unidadeMedida)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DetalheCustoModel &&
        other.categoria == categoria &&
        other.descricao == descricao &&
        other.custo == custo &&
        other.data == data &&
        other.produtoNome == produtoNome &&
        other.quantidade == quantidade &&
        other.unidadeMedida == unidadeMedida;
  }

  @override
  int get hashCode {
    return categoria.hashCode ^
        descricao.hashCode ^
        custo.hashCode ^
        data.hashCode ^
        produtoNome.hashCode ^
        quantidade.hashCode ^
        unidadeMedida.hashCode;
  }
}
