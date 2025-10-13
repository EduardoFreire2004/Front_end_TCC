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

// -------------------------------------------------------------
// RELATÓRIO DE AGROTÓXICOS
// -------------------------------------------------------------

class RelatorioAgrotoxicoDTO {
  final int id;
  final String nome;
  final String tipo;
  final String fornecedor;
  final String unidadeMedida;
  final double qtde;
  final double preco;
  final DateTime dataHora;

  RelatorioAgrotoxicoDTO({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.fornecedor,
    required this.unidadeMedida,
    required this.qtde,
    required this.preco,
    required this.dataHora,
  });

  factory RelatorioAgrotoxicoDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioAgrotoxicoDTO(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      fornecedor: json['fonecedor'] ?? '', // Mantido igual ao backend
      unidadeMedida: json['unidadeMedida'] ?? '',
      qtde: (json['qtde'] ?? 0).toDouble(),
      preco: (json['preco'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'tipo': tipo,
        'fonecedor': fornecedor,
        'unidadeMedida': unidadeMedida,
        'qtde': qtde,
        'preco': preco,
        'dataHora': dataHora.toIso8601String(),
      };
}

// -------------------------------------------------------------
// RELATÓRIO DE INSUMOS
// -------------------------------------------------------------

class RelatorioInsumoDTO {
  final int id;
  final String nome;
  final String categoria;
  final String fornecedor;
  final String unidadeMedida;
  final double qtde;
  final double preco;
  final DateTime dataHora;

  RelatorioInsumoDTO({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.fornecedor,
    required this.unidadeMedida,
    required this.qtde,
    required this.preco,
    required this.dataHora,
  });

  factory RelatorioInsumoDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioInsumoDTO(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      fornecedor: json['fonecedor'] ?? '',
      unidadeMedida: json['unidadeMedida'] ?? '',
      qtde: (json['qtde'] ?? 0).toDouble(),
      preco: (json['preco'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
        'fonecedor': fornecedor,
        'unidadeMedida': unidadeMedida,
        'qtde': qtde,
        'preco': preco,
        'dataHora': dataHora.toIso8601String(),
      };
}

// -------------------------------------------------------------
// RELATÓRIO DE SEMENTES
// -------------------------------------------------------------

class RelatorioSementeDTO {
  final int id;
  final String nome;
  final String tipo;
  final String fornecedor;
  final String marca;
  final double preco;
  final DateTime dataHora;

  RelatorioSementeDTO({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.fornecedor,
    required this.marca,
    required this.preco,
    required this.dataHora,
  });

  factory RelatorioSementeDTO.fromJson(Map<String, dynamic> json) {
    return RelatorioSementeDTO(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      fornecedor: json['fonecedor'] ?? '',
      marca: json['marca'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'tipo': tipo,
        'fonecedor': fornecedor,
        'marca': marca,
        'preco': preco,
        'dataHora': dataHora.toIso8601String(),
      };
}

