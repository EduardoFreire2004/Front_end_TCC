class RelatorioGeralDto {
  final LavouraDto lavoura;
  final PeriodoDto periodo;
  final ResumoGeralDto resumo;

  RelatorioGeralDto({
    required this.lavoura,
    required this.periodo,
    required this.resumo,
  });

  factory RelatorioGeralDto.fromJson(Map<String, dynamic> json) {
    return RelatorioGeralDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      periodo: PeriodoDto.fromJson(json['periodo']),
      resumo: ResumoGeralDto.fromJson(json['resumo']),
    );
  }
}

class RelatorioPlantiosDto {
  final LavouraDto lavoura;
  final EstatisticasPlantiosDto estatisticas;
  final List<PlantioDto> plantios;

  RelatorioPlantiosDto({
    required this.lavoura,
    required this.estatisticas,
    required this.plantios,
  });

  factory RelatorioPlantiosDto.fromJson(Map<String, dynamic> json) {
    return RelatorioPlantiosDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      estatisticas: EstatisticasPlantiosDto.fromJson(json['estatisticas']),
      plantios:
          (json['plantios'] as List)
              .map((p) => PlantioDto.fromJson(p))
              .toList(),
    );
  }
}

class RelatorioAplicacoesDto {
  final LavouraDto lavoura;
  final EstatisticasAplicacoesDto estatisticas;
  final List<AplicacaoDto> aplicacoes;

  RelatorioAplicacoesDto({
    required this.lavoura,
    required this.estatisticas,
    required this.aplicacoes,
  });

  factory RelatorioAplicacoesDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacoesDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      estatisticas: EstatisticasAplicacoesDto.fromJson(json['estatisticas']),
      aplicacoes:
          (json['aplicacoes'] as List)
              .map((a) => AplicacaoDto.fromJson(a))
              .toList(),
    );
  }
}

// Novo modelo para a resposta real do backend
class RelatorioAplicacoesResponseDto {
  final bool success;
  final List<AplicacaoDto> data;
  final int totalRegistros;
  final String? error;

  RelatorioAplicacoesResponseDto({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioAplicacoesResponseDto.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacoesResponseDto(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((a) => AplicacaoDto.fromJson(a))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

class RelatorioColheitasDto {
  final LavouraDto lavoura;
  final EstatisticasColheitasDto estatisticas;
  final List<ColheitaDto> colheitas;

  RelatorioColheitasDto({
    required this.lavoura,
    required this.estatisticas,
    required this.colheitas,
  });

  factory RelatorioColheitasDto.fromJson(Map<String, dynamic> json) {
    return RelatorioColheitasDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      estatisticas: EstatisticasColheitasDto.fromJson(json['estatisticas']),
      colheitas:
          (json['colheitas'] as List)
              .map((c) => ColheitaDto.fromJson(c))
              .toList(),
    );
  }
}

class RelatorioCustosDto {
  final LavouraDto lavoura;
  final EstatisticasCustosDto estatisticas;
  final List<CustoDto> custos;

  RelatorioCustosDto({
    required this.lavoura,
    required this.estatisticas,
    required this.custos,
  });

  factory RelatorioCustosDto.fromJson(Map<String, dynamic> json) {
    return RelatorioCustosDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      estatisticas: EstatisticasCustosDto.fromJson(json['estatisticas']),
      custos:
          (json['custos'] as List).map((c) => CustoDto.fromJson(c)).toList(),
    );
  }
}

class RelatorioEstoqueDto {
  final LavouraDto lavoura;
  final EstatisticasEstoqueDto estatisticas;
  final Map<String, double> saldoAtual;
  final List<MovimentacaoDto> movimentacoes;

  RelatorioEstoqueDto({
    required this.lavoura,
    required this.estatisticas,
    required this.saldoAtual,
    required this.movimentacoes,
  });

  factory RelatorioEstoqueDto.fromJson(Map<String, dynamic> json) {
    return RelatorioEstoqueDto(
      lavoura: LavouraDto.fromJson(json['lavoura']),
      estatisticas: EstatisticasEstoqueDto.fromJson(json['estatisticas']),
      saldoAtual: Map<String, double>.from(json['saldoAtual'] ?? {}),
      movimentacoes:
          (json['movimentacoes'] as List)
              .map((m) => MovimentacaoDto.fromJson(m))
              .toList(),
    );
  }
}

// Classes auxiliares
class LavouraDto {
  final String nome;
  final double area;

  LavouraDto({required this.nome, required this.area});

  factory LavouraDto.fromJson(Map<String, dynamic> json) {
    return LavouraDto(
      nome: json['nome'] ?? '',
      area: (json['area'] ?? 0.0).toDouble(),
    );
  }
}

class PeriodoDto {
  final String inicio;
  final String fim;

  PeriodoDto({required this.inicio, required this.fim});

  factory PeriodoDto.fromJson(Map<String, dynamic> json) {
    return PeriodoDto(inicio: json['inicio'] ?? '', fim: json['fim'] ?? '');
  }
}

class ResumoGeralDto {
  final int totalPlantios;
  final int totalAplicacoesAgrotoxicos;
  final int totalAplicacoesInsumos;
  final int totalColheitas;
  final double custoTotal;
  final double? receitaTotal;
  final double? lucroEstimado;

  ResumoGeralDto({
    required this.totalPlantios,
    required this.totalAplicacoesAgrotoxicos,
    required this.totalAplicacoesInsumos,
    required this.totalColheitas,
    required this.custoTotal,
    this.receitaTotal,
    this.lucroEstimado,
  });

  factory ResumoGeralDto.fromJson(Map<String, dynamic> json) {
    return ResumoGeralDto(
      totalPlantios: json['totalPlantios'] ?? 0,
      totalAplicacoesAgrotoxicos: json['totalAplicacoesAgrotoxicos'] ?? 0,
      totalAplicacoesInsumos: json['totalAplicacoesInsumos'] ?? 0,
      totalColheitas: json['totalColheitas'] ?? 0,
      custoTotal: (json['custoTotal'] ?? 0.0).toDouble(),
      receitaTotal: json['receitaTotal']?.toDouble(),
      lucroEstimado: json['lucroEstimado']?.toDouble(),
    );
  }
}

class EstatisticasPlantiosDto {
  final String periodoAnalisado;
  final int totalPlantios;
  final double areaTotalPlantada;

  EstatisticasPlantiosDto({
    required this.periodoAnalisado,
    required this.totalPlantios,
    required this.areaTotalPlantada,
  });

  factory EstatisticasPlantiosDto.fromJson(Map<String, dynamic> json) {
    return EstatisticasPlantiosDto(
      periodoAnalisado: json['periodoAnalisado'] ?? '',
      totalPlantios: json['totalPlantios'] ?? 0,
      areaTotalPlantada: (json['areaTotalPlantada'] ?? 0.0).toDouble(),
    );
  }
}

class EstatisticasAplicacoesDto {
  final int totalAplicacoes;
  final double areaTotalAplicada;
  final double? custoTotal;

  EstatisticasAplicacoesDto({
    required this.totalAplicacoes,
    required this.areaTotalAplicada,
    this.custoTotal,
  });

  factory EstatisticasAplicacoesDto.fromJson(Map<String, dynamic> json) {
    return EstatisticasAplicacoesDto(
      totalAplicacoes: json['totalAplicacoes'] ?? 0,
      areaTotalAplicada: (json['areaTotalAplicada'] ?? 0.0).toDouble(),
      custoTotal: json['custoTotal']?.toDouble(),
    );
  }
}

class EstatisticasColheitasDto {
  final int totalColheitas;
  final double areaTotalColhida;
  final double quantidadeTotal;
  final double produtividadeMedia;

  EstatisticasColheitasDto({
    required this.totalColheitas,
    required this.areaTotalColhida,
    required this.quantidadeTotal,
    required this.produtividadeMedia,
  });

  factory EstatisticasColheitasDto.fromJson(Map<String, dynamic> json) {
    return EstatisticasColheitasDto(
      totalColheitas: json['totalColheitas'] ?? 0,
      areaTotalColhida: (json['areaTotalColhida'] ?? 0.0).toDouble(),
      quantidadeTotal: (json['quantidadeTotal'] ?? 0.0).toDouble(),
      produtividadeMedia: (json['produtividadeMedia'] ?? 0.0).toDouble(),
    );
  }
}

class EstatisticasCustosDto {
  final String periodoAnalisado;
  final int totalCustos;
  final double custoTotal;
  final double? custoPorHectare;
  final Map<String, double> categorias;

  EstatisticasCustosDto({
    required this.periodoAnalisado,
    required this.totalCustos,
    required this.custoTotal,
    this.custoPorHectare,
    required this.categorias,
  });

  factory EstatisticasCustosDto.fromJson(Map<String, dynamic> json) {
    return EstatisticasCustosDto(
      periodoAnalisado: json['periodoAnalisado'] ?? '',
      totalCustos: json['totalCustos'] ?? 0,
      custoTotal: (json['custoTotal'] ?? 0.0).toDouble(),
      custoPorHectare: json['custoPorHectare']?.toDouble(),
      categorias: Map<String, double>.from(json['categorias'] ?? {}),
    );
  }
}

class EstatisticasEstoqueDto {
  final int totalEntradas;
  final int totalSaidas;
  final int produtosEmEstoque;
  final double? valorEstoque;

  EstatisticasEstoqueDto({
    required this.totalEntradas,
    required this.totalSaidas,
    required this.produtosEmEstoque,
    this.valorEstoque,
  });

  factory EstatisticasEstoqueDto.fromJson(Map<String, dynamic> json) {
    return EstatisticasEstoqueDto(
      totalEntradas: json['totalEntradas'] ?? 0,
      totalSaidas: json['totalSaidas'] ?? 0,
      produtosEmEstoque: json['produtosEmEstoque'] ?? 0,
      valorEstoque: json['valorEstoque']?.toDouble(),
    );
  }
}

class PlantioDto {
  final String cultura;
  final String dataPlantio;
  final double areaPlantada;
  final String status;

  PlantioDto({
    required this.cultura,
    required this.dataPlantio,
    required this.areaPlantada,
    required this.status,
  });

  factory PlantioDto.fromJson(Map<String, dynamic> json) {
    return PlantioDto(
      cultura: json['cultura'] ?? '',
      dataPlantio: json['dataPlantio'] ?? '',
      areaPlantada: (json['areaPlantada'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class AplicacaoDto {
  final int id;
  final String produto;
  final String lavoura;
  final String dataAplicacao;
  final double quantidade;
  final String unidadeMedida;
  final String observacoes;

  AplicacaoDto({
    required this.id,
    required this.produto,
    required this.lavoura,
    required this.dataAplicacao,
    required this.quantidade,
    required this.unidadeMedida,
    required this.observacoes,
  });

  factory AplicacaoDto.fromJson(Map<String, dynamic> json) {
    return AplicacaoDto(
      id: json['id'] ?? 0,
      produto: json['produto'] ?? '',
      lavoura: json['lavoura'] ?? '',
      dataAplicacao: json['dataAplicacao'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      unidadeMedida: json['unidadeMedida'] ?? '',
      observacoes: json['observacoes'] ?? '',
    );
  }
}

class ColheitaDto {
  final String cultura;
  final String dataColheita;
  final double areaColhida;
  final double quantidadeColhida;
  final double produtividade;

  ColheitaDto({
    required this.cultura,
    required this.dataColheita,
    required this.areaColhida,
    required this.quantidadeColhida,
    required this.produtividade,
  });

  factory ColheitaDto.fromJson(Map<String, dynamic> json) {
    return ColheitaDto(
      cultura: json['cultura'] ?? '',
      dataColheita: json['dataColheita'] ?? '',
      areaColhida: (json['areaColhida'] ?? 0.0).toDouble(),
      quantidadeColhida: (json['quantidadeColhida'] ?? 0.0).toDouble(),
      produtividade: (json['produtividade'] ?? 0.0).toDouble(),
    );
  }
}

class CustoDto {
  final String descricao;
  final DateTime data;
  final double valor;

  CustoDto({required this.descricao, required this.data, required this.valor});

  factory CustoDto.fromJson(Map<String, dynamic> json) {
    return CustoDto(
      descricao: json['descricao'] ?? '',
      data: DateTime.parse(json['data'] ?? DateTime.now().toIso8601String()),
      valor: (json['valor'] ?? 0.0).toDouble(),
    );
  }
}

class MovimentacaoDto {
  final String produto;
  final String tipo;
  final String data;
  final double quantidade;
  final String unidade;

  MovimentacaoDto({
    required this.produto,
    required this.tipo,
    required this.data,
    required this.quantidade,
    required this.unidade,
  });

  factory MovimentacaoDto.fromJson(Map<String, dynamic> json) {
    return MovimentacaoDto(
      produto: json['produto'] ?? '',
      tipo: json['tipo'] ?? '',
      data: json['data'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      unidade: json['unidade'] ?? '',
    );
  }
}
