import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoInsumoModel.dart';
import 'package:flutter_fgl_1/repositories/AplicacaoRepo.dart';
import 'package:flutter_fgl_1/repositories/AplicacaoInsumoRepo.dart';

class AplicacaoService {
  final AplicacaoRepo _aplicacaoRepo = AplicacaoRepo();
  final AplicacaoInsumoRepo _aplicacaoInsumoRepo = AplicacaoInsumoRepo();

  // ===== APLICAÇÕES DE AGROTÓXICOS =====

  /// Cria uma nova aplicação de agrotóxico
  /// Retorna a aplicação criada com todos os campos preenchidos
  Future<AplicacaoModel> criarAplicacaoAgrotoxico({
    required int lavouraId,
    required int agrotoxicoId,
    required double quantidade,
    required DateTime dataHora,
    String? descricao,
  }) async {
    try {
      // Validações básicas
      _validarQuantidade(quantidade);
      _validarDataHora(dataHora);

      // Criar modelo da aplicação
      final aplicacao = AplicacaoModel(
        lavouraID: lavouraId,
        agrotoxicoID: agrotoxicoId,
        qtde: quantidade,
        dataHora: dataHora,
        descricao: descricao,
      );

      // Criar aplicação (a API fará validação de estoque)
      final aplicacaoCriada = await _aplicacaoRepo.create(aplicacao);

      return aplicacaoCriada;
    } catch (e) {
      throw Exception('Erro ao criar aplicação de agrotóxico: $e');
    }
  }

  /// Atualiza uma aplicação de agrotóxico existente
  /// A API ajustará automaticamente o estoque
  Future<void> atualizarAplicacaoAgrotoxico(AplicacaoModel aplicacao) async {
    try {
      // Validações básicas
      _validarQuantidade(aplicacao.qtde);
      _validarDataHora(aplicacao.dataHora);

      // Atualizar aplicação (a API ajustará o estoque)
      await _aplicacaoRepo.update(aplicacao);
    } catch (e) {
      throw Exception('Erro ao atualizar aplicação de agrotóxico: $e');
    }
  }

  /// Exclui uma aplicação de agrotóxico
  /// A API retornará automaticamente a quantidade ao estoque
  Future<void> excluirAplicacaoAgrotoxico(int id) async {
    try {
      await _aplicacaoRepo.delete(id);
    } catch (e) {
      throw Exception('Erro ao excluir aplicação de agrotóxico: $e');
    }
  }

  /// Busca aplicações de agrotóxicos por lavoura
  Future<List<AplicacaoModel>> buscarAplicacoesAgrotoxicoPorLavoura(
    int lavouraId,
  ) async {
    try {
      return await _aplicacaoRepo.fetchByLavoura(lavouraId);
    } catch (e) {
      throw Exception(
        'Erro ao buscar aplicações de agrotóxicos por lavoura: $e',
      );
    }
  }

  /// Busca aplicações de agrotóxicos com filtros
  Future<List<AplicacaoModel>> buscarAplicacoesAgrotoxicoComFiltros({
    int? lavouraId,
    int? agrotoxicoId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      return await _aplicacaoRepo.buscarComFiltros(
        lavouraId: lavouraId,
        agrotoxicoId: agrotoxicoId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    } catch (e) {
      throw Exception(
        'Erro ao buscar aplicações de agrotóxicos com filtros: $e',
      );
    }
  }

  /// Busca uma aplicação de agrotóxico por ID
  Future<AplicacaoModel?> buscarAplicacaoAgrotoxicoPorId(int id) async {
    try {
      return await _aplicacaoRepo.getById(id);
    } catch (e) {
      throw Exception('Erro ao buscar aplicação de agrotóxico por ID: $e');
    }
  }

  // ===== APLICAÇÕES DE INSUMOS =====

  /// Cria uma nova aplicação de insumo
  /// Retorna a aplicação criada com todos os campos preenchidos
  Future<AplicacaoInsumoModel> criarAplicacaoInsumo({
    required int lavouraId,
    required int insumoId,
    required double quantidade,
    required DateTime dataHora,
    String? descricao,
  }) async {
    try {
      // Validações básicas
      _validarQuantidade(quantidade);
      _validarDataHora(dataHora);

      // Criar modelo da aplicação
      final aplicacao = AplicacaoInsumoModel(
        lavouraID: lavouraId,
        insumoID: insumoId,
        qtde: quantidade,
        dataHora: dataHora,
        descricao: descricao,
      );

      // Criar aplicação (a API fará validação de estoque)
      final aplicacaoCriada = await _aplicacaoInsumoRepo.create(aplicacao);

      return aplicacaoCriada;
    } catch (e) {
      throw Exception('Erro ao criar aplicação de insumo: $e');
    }
  }

  /// Atualiza uma aplicação de insumo existente
  /// A API ajustará automaticamente o estoque
  Future<void> atualizarAplicacaoInsumo(AplicacaoInsumoModel aplicacao) async {
    try {
      // Validações básicas
      _validarQuantidade(aplicacao.qtde);
      _validarDataHora(aplicacao.dataHora);

      // Atualizar aplicação (a API ajustará o estoque)
      await _aplicacaoInsumoRepo.update(aplicacao);
    } catch (e) {
      throw Exception('Erro ao atualizar aplicação de insumo: $e');
    }
  }

  /// Exclui uma aplicação de insumo
  /// A API retornará automaticamente a quantidade ao estoque
  Future<void> excluirAplicacaoInsumo(int id) async {
    try {
      await _aplicacaoInsumoRepo.delete(id);
    } catch (e) {
      throw Exception('Erro ao excluir aplicação de insumo: $e');
    }
  }

  /// Busca aplicações de insumos por lavoura
  Future<List<AplicacaoInsumoModel>> buscarAplicacoesInsumoPorLavoura(
    int lavouraId,
  ) async {
    try {
      return await _aplicacaoInsumoRepo.fetchByLavoura(lavouraId);
    } catch (e) {
      throw Exception('Erro ao buscar aplicações de insumos por lavoura: $e');
    }
  }

  /// Busca aplicações de insumos com filtros
  Future<List<AplicacaoInsumoModel>> buscarAplicacoesInsumoComFiltros({
    int? lavouraId,
    int? insumoId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      return await _aplicacaoInsumoRepo.buscarComFiltros(
        lavouraId: lavouraId,
        insumoId: insumoId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    } catch (e) {
      throw Exception('Erro ao buscar aplicações de insumos com filtros: $e');
    }
  }

  /// Busca uma aplicação de insumo por ID
  Future<AplicacaoInsumoModel?> buscarAplicacaoInsumoPorId(int id) async {
    try {
      return await _aplicacaoInsumoRepo.getById(id);
    } catch (e) {
      throw Exception('Erro ao buscar aplicação de insumo por ID: $e');
    }
  }

  // ===== VALIDAÇÕES =====

  /// Valida se a quantidade é positiva
  void _validarQuantidade(double quantidade) {
    if (quantidade <= 0) {
      throw Exception('A quantidade deve ser maior que zero');
    }
  }

  /// Valida se a data/hora é válida
  void _validarDataHora(DateTime dataHora) {
    final agora = DateTime.now();
    if (dataHora.isAfter(agora.add(const Duration(days: 1)))) {
      throw Exception('A data/hora não pode ser no futuro');
    }
  }

  // ===== MÉTODOS UTILITÁRIOS =====

  /// Busca todas as aplicações de agrotóxicos
  Future<List<AplicacaoModel>> buscarTodasAplicacoesAgrotoxico() async {
    try {
      return await _aplicacaoRepo.getAll();
    } catch (e) {
      throw Exception('Erro ao buscar todas as aplicações de agrotóxicos: $e');
    }
  }

  /// Busca todas as aplicações de insumos
  Future<List<AplicacaoInsumoModel>> buscarTodasAplicacoesInsumo() async {
    try {
      return await _aplicacaoInsumoRepo.getAll();
    } catch (e) {
      throw Exception('Erro ao buscar todas as aplicações de insumos: $e');
    }
  }

  /// Formata quantidade para exibição
  String formatarQuantidade(double quantidade, String? unidadeMedida) {
    final unidade = unidadeMedida ?? '';
    return '${quantidade.toStringAsFixed(2)} $unidade';
  }

  /// Formata data/hora para exibição
  String formatarDataHora(DateTime dataHora) {
    return '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
  }

  /// Verifica se uma aplicação pode ser editada
  /// Por padrão, permite edição de aplicações até 30 dias atrás
  bool podeEditarAplicacao(DateTime dataHora) {
    final agora = DateTime.now();
    final limite = agora.subtract(const Duration(days: 30));
    return dataHora.isAfter(limite);
  }

  /// Verifica se uma aplicação pode ser excluída
  /// Por padrão, permite exclusão de aplicações até 7 dias atrás
  bool podeExcluirAplicacao(DateTime dataHora) {
    final agora = DateTime.now();
    final limite = agora.subtract(const Duration(days: 7));
    return dataHora.isAfter(limite);
  }
}
