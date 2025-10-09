class RelatorioAplicacaoDTO {
  final int id;
  final String lavoura;
  final String agrotoxico;
  final String fornecedor;
  final double quantidade;
  final DateTime dataHora;

  RelatorioAplicacaoDTO({
    required this.id,
    required this.lavoura,
    required this.agrotoxico,
    required this.fornecedor,
    required this.quantidade,
    required this.dataHora,
  });

  factory RelatorioAplicacaoDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoDTO(
      id: json['id'] ?? 0,
      lavoura: json['lavoura'] ?? '',
      agrotoxico: json['agrotoxico'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      quantidade: (json['quantidade'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lavoura': lavoura,
    'agrotoxico': agrotoxico,
    'fornecedor': fornecedor,
    'quantidade': quantidade,
    'dataHora': dataHora.toIso8601String(),
  };
}

// -------------------------------------------------------------

class RelatorioAplicacaoInsumoDTO {
  final int id;
  final String lavoura;
  final String insumo;
  final String fornecedor;
  final double quantidade;
  final DateTime dataHora;

  RelatorioAplicacaoInsumoDTO({
    required this.id,
    required this.lavoura,
    required this.insumo,
    required this.fornecedor,
    required this.quantidade,
    required this.dataHora,
  });

  factory RelatorioAplicacaoInsumoDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoInsumoDTO(
      id: json['id'] ?? 0,
      lavoura: json['lavoura'] ?? '',
      insumo: json['insumo'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      quantidade: (json['quantidade'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lavoura': lavoura,
    'insumo': insumo,
    'fornecedor': fornecedor,
    'quantidade': quantidade,
    'dataHora': dataHora.toIso8601String(),
  };
}

// -------------------------------------------------------------

class RelatorioPlantioDTO {
  final int id;
  final String lavoura;
  final String semente;
  final String fornecedor;
  final double areaPlantada;
  final double quantidade;
  final DateTime dataHora;

  RelatorioPlantioDTO({
    required this.id,
    required this.lavoura,
    required this.semente,
    required this.fornecedor,
    required this.areaPlantada,
    required this.quantidade,
    required this.dataHora,
  });

  factory RelatorioPlantioDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioPlantioDTO(
      id: json['id'] ?? 0,
      lavoura: json['lavoura'] ?? '',
      semente: json['semente'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      areaPlantada: (json['areaPlantada'] ?? 0).toDouble(),
      quantidade: (json['quantidade'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lavoura': lavoura,
    'semente': semente,
    'fornecedor': fornecedor,
    'areaPlantada': areaPlantada,
    'quantidade': quantidade,
    'dataHora': dataHora.toIso8601String(),
  };
}

// -------------------------------------------------------------

class RelatorioColheitaDTO {
  final int id;
  final String lavoura;
  final double quantidadeSacas;
  final double areaHa;
  final String cooperativaDestino;
  final double precoSaca;
  final DateTime dataHora;

  RelatorioColheitaDTO({
    required this.id,
    required this.lavoura,
    required this.quantidadeSacas,
    required this.areaHa,
    required this.cooperativaDestino,
    required this.precoSaca,
    required this.dataHora,
  });

  factory RelatorioColheitaDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioColheitaDTO(
      id: json['id'] ?? 0,
      lavoura: json['lavoura'] ?? '',
      quantidadeSacas: (json['quantidadeSacas'] ?? 0).toDouble(),
      areaHa: (json['areaHa'] ?? 0).toDouble(),
      cooperativaDestino: json['cooperativaDestino'] ?? '',
      precoSaca: (json['precoSaca'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lavoura': lavoura,
    'quantidadeSacas': quantidadeSacas,
    'areaHa': areaHa,
    'cooperativaDestino': cooperativaDestino,
    'precoSaca': precoSaca,
    'dataHora': dataHora.toIso8601String(),
  };
}

// -------------------------------------------------------------

class RelatorioMovimentacaoDTO {
  final int id;
  final String lavoura;
  final String item;
  final String tipo;
  final double quantidade;
  final DateTime dataHora;

  RelatorioMovimentacaoDTO({
    required this.id,
    required this.lavoura,
    required this.item,
    required this.tipo,
    required this.quantidade,
    required this.dataHora,
  });

  factory RelatorioMovimentacaoDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioMovimentacaoDTO(
      id: json['id'] ?? 0,
      lavoura: json['lavoura'] ?? '',
      item: json['item'] ?? '',
      tipo: json['tipo'] ?? '',
      quantidade: (json['quantidade'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lavoura': lavoura,
    'item': item,
    'tipo': tipo,
    'quantidade': quantidade,
    'dataHora': dataHora.toIso8601String(),
  };
}
