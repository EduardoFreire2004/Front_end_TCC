// Modelos para a nova API de relatórios
// Baseado na documentação fornecida

// Estrutura base de resposta da API
class RelatorioResponse<T> {
  final bool success;
  final List<T> data;
  final int totalRegistros;
  final String? error;

  RelatorioResponse({
    required this.success,
    required this.data,
    required this.totalRegistros,
    this.error,
  });

  factory RelatorioResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return RelatorioResponse<T>(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRegistros: json['totalRegistros'] ?? 0,
      error: json['error'],
    );
  }
}

// Modelo para Relatório de Fornecedores
class RelatorioFornecedor {
  final int id;
  final String nome;
  final String cnpj;
  final String telefone;
  final int totalProdutos;
  final double valorTotalProdutos;

  RelatorioFornecedor({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.totalProdutos,
    required this.valorTotalProdutos,
  });

  factory RelatorioFornecedor.fromJson(Map<String, dynamic> json) {
    return RelatorioFornecedor(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cnpj: json['cnpj'] ?? '',
      telefone: json['telefone'] ?? '',
      totalProdutos: json['totalProdutos'] ?? 0,
      valorTotalProdutos: (json['valorTotalProdutos'] ?? 0.0).toDouble(),
    );
  }
}

// Modelo para Relatório de Aplicações (Agrotóxicos)
class RelatorioAplicacao {
  final int id;
  final String produto;
  final String lavoura;
  final DateTime dataAplicacao;
  final double quantidade;
  final String unidadeMedida;
  final String? observacoes;

  RelatorioAplicacao({
    required this.id,
    required this.produto,
    required this.lavoura,
    required this.dataAplicacao,
    required this.quantidade,
    required this.unidadeMedida,
    this.observacoes,
  });

  factory RelatorioAplicacao.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacao(
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

// Modelo para Relatório de Aplicações de Insumos
class RelatorioAplicacaoInsumo {
  final int id;
  final String insumo;
  final String lavoura;
  final DateTime dataAplicacao;
  final double quantidade;
  final String? descricao;

  RelatorioAplicacaoInsumo({
    required this.id,
    required this.insumo,
    required this.lavoura,
    required this.dataAplicacao,
    required this.quantidade,
    this.descricao,
  });

  factory RelatorioAplicacaoInsumo.fromJson(Map<String, dynamic> json) {
    return RelatorioAplicacaoInsumo(
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

// Modelo para Relatório de Sementes
class RelatorioSemente {
  final int id;
  final String nome;
  final String tipo;
  final String marca;
  final String fornecedor;
  final double quantidade;
  final double preco;
  final DateTime dataCadastro;
  final double valorTotal;

  RelatorioSemente({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.marca,
    required this.fornecedor,
    required this.quantidade,
    required this.preco,
    required this.dataCadastro,
    required this.valorTotal,
  });

  factory RelatorioSemente.fromJson(Map<String, dynamic> json) {
    return RelatorioSemente(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      marca: json['marca'] ?? '',
      fornecedor: json['fornecedor'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      preco: (json['preco'] ?? 0.0).toDouble(),
      dataCadastro:
          DateTime.tryParse(json['dataCadastro'] ?? '') ?? DateTime.now(),
      valorTotal: (json['valorTotal'] ?? 0.0).toDouble(),
    );
  }
}

// Modelo para Relatório de Insumos
class RelatorioInsumo {
  final int id;
  final String nome;
  final String categoria;
  final String fornecedor;
  final double quantidade;
  final double preco;
  final String unidadeMedida;
  final DateTime dataCadastro;
  final double valorTotal;

  RelatorioInsumo({
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

  factory RelatorioInsumo.fromJson(Map<String, dynamic> json) {
    return RelatorioInsumo(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
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

// Modelo para Relatório de Agrotóxicos
class RelatorioAgrotoxico {
  final int id;
  final String nome;
  final String tipo;
  final String fornecedor;
  final double quantidade;
  final double preco;
  final String unidadeMedida;
  final DateTime dataCadastro;
  final double valorTotal;

  RelatorioAgrotoxico({
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

  factory RelatorioAgrotoxico.fromJson(Map<String, dynamic> json) {
    return RelatorioAgrotoxico(
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

// Modelo para Relatório de Colheitas
class RelatorioColheita {
  final int id;
  final String cultura;
  final String lavoura;
  final DateTime dataColheita;
  final double quantidadeColhida;
  final double produtividade;
  final String? observacoes;

  RelatorioColheita({
    required this.id,
    required this.cultura,
    required this.lavoura,
    required this.dataColheita,
    required this.quantidadeColhida,
    required this.produtividade,
    this.observacoes,
  });

  factory RelatorioColheita.fromJson(Map<String, dynamic> json) {
    return RelatorioColheita(
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

// Modelo para Relatório de Movimentação de Estoque
class RelatorioMovimentacaoEstoque {
  final int id;
  final String tipoMovimentacao;
  final String produto;
  final double quantidade;
  final String unidade;
  final DateTime data;
  final String? observacoes;

  RelatorioMovimentacaoEstoque({
    required this.id,
    required this.tipoMovimentacao,
    required this.produto,
    required this.quantidade,
    required this.unidade,
    required this.data,
    this.observacoes,
  });

  factory RelatorioMovimentacaoEstoque.fromJson(Map<String, dynamic> json) {
    return RelatorioMovimentacaoEstoque(
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

// Modelo para Relatório de Plantios
class RelatorioPlantio {
  final int id;
  final String cultura;
  final String lavoura;
  final DateTime dataPlantio;
  final double areaPlantada;
  final String status;
  final String? observacoes;

  RelatorioPlantio({
    required this.id,
    required this.cultura,
    required this.lavoura,
    required this.dataPlantio,
    required this.areaPlantada,
    required this.status,
    this.observacoes,
  });

  factory RelatorioPlantio.fromJson(Map<String, dynamic> json) {
    return RelatorioPlantio(
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

// Tipos de relatórios disponíveis
enum TipoRelatorio {
  fornecedores,
  aplicacao,
  aplicacaoInsumo,
  semente,
  insumo,
  agrotoxico,
  colheita,
  movimentacaoEstoque,
  plantio,
}

// Extensão para facilitar o uso dos tipos
extension TipoRelatorioExtension on TipoRelatorio {
  String get nome {
    switch (this) {
      case TipoRelatorio.fornecedores:
        return 'Fornecedores';
      case TipoRelatorio.aplicacao:
        return 'Aplicações de Agrotóxicos';
      case TipoRelatorio.aplicacaoInsumo:
        return 'Aplicações de Insumos';
      case TipoRelatorio.semente:
        return 'Sementes';
      case TipoRelatorio.insumo:
        return 'Insumos';
      case TipoRelatorio.agrotoxico:
        return 'Agrotóxicos';
      case TipoRelatorio.colheita:
        return 'Colheitas';
      case TipoRelatorio.movimentacaoEstoque:
        return 'Movimentação de Estoque';
      case TipoRelatorio.plantio:
        return 'Plantios';
    }
  }

  String get descricao {
    switch (this) {
      case TipoRelatorio.fornecedores:
        return 'Lista de fornecedores e produtos';
      case TipoRelatorio.aplicacao:
        return 'Histórico de aplicações de agrotóxicos';
      case TipoRelatorio.aplicacaoInsumo:
        return 'Histórico de aplicações de insumos';
      case TipoRelatorio.semente:
        return 'Controle de sementes';
      case TipoRelatorio.insumo:
        return 'Controle de estoque de insumos';
      case TipoRelatorio.agrotoxico:
        return 'Controle de estoque de agrotóxicos';
      case TipoRelatorio.colheita:
        return 'Resultados das colheitas';
      case TipoRelatorio.movimentacaoEstoque:
        return 'Movimentações de estoque';
      case TipoRelatorio.plantio:
        return 'Histórico de plantios';
    }
  }

  String get endpoint {
    switch (this) {
      case TipoRelatorio.fornecedores:
        return 'fornecedores';
      case TipoRelatorio.aplicacao:
        return 'aplicacao';
      case TipoRelatorio.aplicacaoInsumo:
        return 'aplicacao-insumo';
      case TipoRelatorio.semente:
        return 'semente';
      case TipoRelatorio.insumo:
        return 'insumo';
      case TipoRelatorio.agrotoxico:
        return 'agrotoxico';
      case TipoRelatorio.colheita:
        return 'colheita';
      case TipoRelatorio.movimentacaoEstoque:
        return 'movimentacao-estoque';
      case TipoRelatorio.plantio:
        return 'plantio';
    }
  }
}




