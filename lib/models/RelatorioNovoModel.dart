

class RelatorioFornecedoresDto {
  final int id;
  final String nome;
  final String cnpj;
  final String telefone;
  final int totalProdutos;
  final double valorTotalProdutos;

  RelatorioFornecedoresDto({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.totalProdutos,
    required this.valorTotalProdutos,
  });

  factory RelatorioFornecedoresDto.fromJson(Map<String, dynamic> json) {
    return RelatorioFornecedoresDto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cnpj: json['cnpj'] ?? '',
      telefone: json['telefone'] ?? '',
      totalProdutos: json['totalProdutos'] ?? 0,
      valorTotalProdutos: (json['valorTotalProdutos'] ?? 0.0).toDouble(),
    );
  }
}

class RelatorioAplicacaoDto {
  final int id;
  final String produto;
  final String lavoura;
  final DateTime dataAplicacao;
  final double quantidade;
  final String unidadeMedida;
  final String? observacoes;

  RelatorioAplicacaoDto({
    required this.id,
    required this.produto,
    required this.lavoura,
    required this.dataAplicacao,
    required this.quantidade,
    required this.unidadeMedida,
    this.observacoes,
  });

  factory RelatorioAplicacaoDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoDto(
      id: json['id'] ?? 0,
      produto: json['produto'] ?? '',
      lavoura: json['lavoura'] ?? '',
      dataAplicacao:
          DateTime.tryParse(json['dataAplicacao'] ?? '') ?? DateTime.now(),
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      unidadeMedida: json['unidadeMedida'] ?? '',
      observacoes: json['observacoes'],
    );
  }
}

class RelatorioAplicacaoInsumoDto {
  final int id;
  final String insumo;
  final String lavoura;
  final DateTime dataAplicacao;
  final double quantidade;
  final String? descricao;

  RelatorioAplicacaoInsumoDto({
    required this.id,
    required this.insumo,
    required this.lavoura,
    required this.dataAplicacao,
    required this.quantidade,
    this.descricao,
  });

  factory RelatorioAplicacaoInsumoDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoInsumoDto(
      id: json['id'] ?? 0,
      insumo: json['insumo'] ?? '',
      lavoura: json['lavoura'] ?? '',
      dataAplicacao:
          DateTime.tryParse(json['dataAplicacao'] ?? '') ?? DateTime.now(),
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      descricao: json['descricao'],
    );
  }
}

class RelatorioInsumoDto {
  final int id;
  final String nome;
  final String categoria;
  final String fornecedor;
  final double quantidade;
  final double preco;
  final String unidadeMedida;
  final DateTime dataCadastro;
  final double valorTotal;

  RelatorioInsumoDto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.fornecedor,
    required this.quantidade,
    required this.preco,
    required this.unidadeMedida,
    required this.dataCadastro,
    required this.valorTotal,
  });

  factory RelatorioInsumoDto.fromJson(Map<String, dynamic> json) {
    return RelatorioInsumoDto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      quantidade: (json['qtde'] ?? 0.0).toDouble(),
      preco: (json['preco'] ?? 0.0).toDouble(),
      unidadeMedida: json['unidadeMedida'] ?? '',
      dataCadastro:
          DateTime.tryParse(json['dataCadastro'] ?? '') ?? DateTime.now(),
      valorTotal: (json['valorTotal'] ?? 0.0).toDouble(),
    );
  }
}

class RelatorioAgrotoxicoDto {
  final int id;
  final String nome;
  final String tipo;
  final String fornecedor;
  final double quantidade;
  final double preco;
  final String unidadeMedida;
  final DateTime dataCadastro;
  final double valorTotal;

  RelatorioAgrotoxicoDto({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.fornecedor,
    required this.quantidade,
    required this.preco,
    required this.unidadeMedida,
    required this.dataCadastro,
    required this.valorTotal,
  });

  factory RelatorioAgrotoxicoDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAgrotoxicoDto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      preco: (json['preco'] ?? 0.0).toDouble(),
      unidadeMedida: json['unidadeMedida'] ?? '',
      dataCadastro:
          DateTime.tryParse(json['dataCadastro'] ?? '') ?? DateTime.now(),
      valorTotal: (json['valorTotal'] ?? 0.0).toDouble(),
    );
  }
}

class RelatorioColheitaDto {
  final int id;
  final String cultura;
  final String lavoura;
  final DateTime dataColheita;
  final double quantidadeColhida;
  final double produtividade;
  final String? observacoes;

  RelatorioColheitaDto({
    required this.id,
    required this.cultura,
    required this.lavoura,
    required this.dataColheita,
    required this.quantidadeColhida,
    required this.produtividade,
    this.observacoes,
  });

  factory RelatorioColheitaDto.fromJson(Map<String, dynamic> json) {
    return RelatorioColheitaDto(
      id: json['id'] ?? 0,
      cultura: json['cultura'] ?? '',
      lavoura: json['lavoura'] ?? '',
      dataColheita:
          DateTime.tryParse(json['dataColheita'] ?? '') ?? DateTime.now(),
      quantidadeColhida: (json['quantidadeColhida'] ?? 0.0).toDouble(),
      produtividade: (json['produtividade'] ?? 0.0).toDouble(),
      observacoes: json['observacoes'],
    );
  }
}

class RelatorioMovimentacaoEstoqueDto {
  final int id;
  final String tipoMovimentacao;
  final String produto;
  final double quantidade;
  final String unidade;
  final DateTime data;
  final String? observacoes;

  RelatorioMovimentacaoEstoqueDto({
    required this.id,
    required this.tipoMovimentacao,
    required this.produto,
    required this.quantidade,
    required this.unidade,
    required this.data,
    this.observacoes,
  });

  factory RelatorioMovimentacaoEstoqueDto.fromJson(Map<String, dynamic> json) {
    return RelatorioMovimentacaoEstoqueDto(
      id: json['id'] ?? 0,
      tipoMovimentacao: json['tipoMovimentacao'] ?? '',
      produto: json['produto'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      unidade: json['unidade'] ?? '',
      data: DateTime.tryParse(json['data'] ?? '') ?? DateTime.now(),
      observacoes: json['observacoes'],
    );
  }
}

class RelatorioPlantioDto {
  final int id;
  final String cultura;
  final String lavoura;
  final DateTime dataPlantio;
  final double areaPlantada;
  final String status;
  final String? observacoes;

  RelatorioPlantioDto({
    required this.id,
    required this.cultura,
    required this.lavoura,
    required this.dataPlantio,
    required this.areaPlantada,
    required this.status,
    this.observacoes,
  });

  factory RelatorioPlantioDto.fromJson(Map<String, dynamic> json) {
    return RelatorioPlantioDto(
      id: json['id'] ?? 0,
      cultura: json['cultura'] ?? '',
      lavoura: json['lavoura'] ?? '',
      dataPlantio:
          DateTime.tryParse(json['dataPlantio'] ?? '') ?? DateTime.now(),
      areaPlantada: (json['areaPlantada'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      observacoes: json['observacoes'],
    );
  }
}

class RelatorioFornecedoresResponseDto {
  final bool success;
  final List<RelatorioFornecedoresDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioFornecedoresResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioFornecedoresResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioFornecedoresResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioFornecedoresDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioAplicacaoResponseDto {
  final bool success;
  final List<RelatorioAplicacaoDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioAplicacaoResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioAplicacaoResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioAplicacaoDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioAplicacaoInsumoResponseDto {
  final bool success;
  final List<RelatorioAplicacaoInsumoDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioAplicacaoInsumoResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioAplicacaoInsumoResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelatorioAplicacaoInsumoResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioAplicacaoInsumoDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioInsumoResponseDto {
  final bool success;
  final List<RelatorioInsumoDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioInsumoResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioInsumoResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioInsumoResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioInsumoDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioAgrotoxicoResponseDto {
  final bool success;
  final List<RelatorioAgrotoxicoDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioAgrotoxicoResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioAgrotoxicoResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAgrotoxicoResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioAgrotoxicoDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioColheitaResponseDto {
  final bool success;
  final List<RelatorioColheitaDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioColheitaResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioColheitaResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioColheitaResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioColheitaDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioMovimentacaoEstoqueResponseDto {
  final bool success;
  final List<RelatorioMovimentacaoEstoqueDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioMovimentacaoEstoqueResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioMovimentacaoEstoqueResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelatorioMovimentacaoEstoqueResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioMovimentacaoEstoqueDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioPlantioResponseDto {
  final bool success;
  final List<RelatorioPlantioDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioPlantioResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioPlantioResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioPlantioResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => RelatorioPlantioDto.fromJson(item))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

