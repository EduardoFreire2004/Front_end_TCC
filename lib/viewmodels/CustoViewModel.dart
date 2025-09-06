import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/CustoCalculadoModel.dart';
import 'package:flutter_fgl_1/models/ResumoCustosModel.dart';
import 'package:flutter_fgl_1/models/HistoricoCustoModel.dart';
import 'package:flutter_fgl_1/services/custo_service.dart';

class CustoViewModel extends ChangeNotifier {
  final CustoService _custoService;

  // Estado dos custos calculados
  CustoCalculadoModel? _custoAtual;
  ResumoCustosModel? _resumoAtual;
  List<HistoricoCustoModel> _historico = [];

  // Estados de loading
  bool _isLoadingCustos = false;
  bool _isLoadingResumo = false;
  bool _isLoadingHistorico = false;
  bool _isUpdating = false;

  // Estados de erro
  String? _errorCustos;
  String? _errorResumo;
  String? _errorHistorico;
  String? _errorUpdate;

  // Filtros de data
  DateTime? _dataInicio;
  DateTime? _dataFim;

  // Construtor
  CustoViewModel(this._custoService);

  // Getters para o estado
  CustoCalculadoModel? get custoAtual => _custoAtual;
  ResumoCustosModel? get resumoAtual => _resumoAtual;
  List<HistoricoCustoModel> get historico => _historico;

  bool get isLoadingCustos => _isLoadingCustos;
  bool get isLoadingResumo => _isLoadingResumo;
  bool get isLoadingHistorico => _isLoadingHistorico;
  bool get isUpdating => _isUpdating;

  String? get errorCustos => _errorCustos;
  String? get errorResumo => _errorResumo;
  String? get errorHistorico => _errorHistorico;
  String? get errorUpdate => _errorUpdate;

  DateTime? get dataInicio => _dataInicio;
  DateTime? get dataFim => _dataFim;

  // 🧮 CALCULAR CUSTOS COMPLETOS DA LAVOURA
  Future<void> calcularCustosLavoura({
    required int lavouraId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      _isLoadingCustos = true;
      _errorCustos = null;
      notifyListeners();

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _custoAtual = await _custoService.calcularCustosLavoura(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _isLoadingCustos = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCustos = false;
      _errorCustos = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 🧮 CALCULAR CUSTOS DO ÚLTIMO MÊS
  Future<void> calcularCustosUltimoMes(int lavouraId) async {
    try {
      _isLoadingCustos = true;
      _errorCustos = null;
      notifyListeners();

      _custoAtual = await _custoService.calcularCustosUltimoMes(lavouraId);

      // Definir período do último mês
      final agora = DateTime.now();
      _dataInicio = DateTime(agora.year, agora.month, 1);
      _dataFim = DateTime(agora.year, agora.month + 1, 0);

      _isLoadingCustos = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCustos = false;
      _errorCustos = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 🧮 CALCULAR CUSTOS DO ÚLTIMO ANO
  Future<void> calcularCustosUltimoAno(int lavouraId) async {
    try {
      _isLoadingCustos = true;
      _errorCustos = null;
      notifyListeners();

      final agora = DateTime.now();
      final dataInicio = DateTime(agora.year, 1, 1);
      final dataFim = DateTime(agora.year, 12, 31);

      _custoAtual = await _custoService.calcularCustosLavoura(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _isLoadingCustos = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCustos = false;
      _errorCustos = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 📈 OBTER RESUMO DE CUSTOS
  Future<void> obterResumoCustos({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      _isLoadingResumo = true;
      _errorResumo = null;
      notifyListeners();

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _resumoAtual = await _custoService.obterResumoCustos(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _isLoadingResumo = false;
      notifyListeners();
    } catch (e) {
      _isLoadingResumo = false;
      _errorResumo = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 📊 OBTER RESUMO DO ÚLTIMO MÊS
  Future<void> obterResumoUltimoMes(int lavouraId) async {
    try {
      _isLoadingResumo = true;
      _errorResumo = null;
      notifyListeners();

      final agora = DateTime.now();
      final dataInicio = DateTime(agora.year, agora.month, 1);
      final dataFim = DateTime(agora.year, agora.month + 1, 0);

      _resumoAtual = await _custoService.obterResumoCustos(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _isLoadingResumo = false;
      notifyListeners();
    } catch (e) {
      _isLoadingResumo = false;
      _errorResumo = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 📊 OBTER RESUMO DO ÚLTIMO ANO
  Future<void> obterResumoUltimoAno(int lavouraId) async {
    try {
      _isLoadingResumo = true;
      _errorResumo = null;
      notifyListeners();

      final agora = DateTime.now();
      final dataInicio = DateTime(agora.year, 1, 1);
      final dataFim = DateTime(agora.year, 12, 31);

      _resumoAtual = await _custoService.obterResumoCustos(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _isLoadingResumo = false;
      notifyListeners();
    } catch (e) {
      _isLoadingResumo = false;
      _errorResumo = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 📊 OBTER HISTÓRICO DE CUSTOS
  Future<void> obterHistoricoCustos({
    required int lavouraId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      _isLoadingHistorico = true;
      _errorHistorico = null;
      notifyListeners();

      _dataInicio = dataInicio;
      _dataFim = dataFim;

      _historico = await _custoService.obterHistoricoCustos(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      _isLoadingHistorico = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistorico = false;
      _errorHistorico = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 🔄 ATUALIZAR CUSTOS DA LAVOURA
  Future<void> atualizarCustosLavoura(int lavouraId) async {
    try {
      _isUpdating = true;
      _errorUpdate = null;
      notifyListeners();

      await _custoService.atualizarCustosLavoura(lavouraId);

      // Recarregar custos após atualização
      if (_dataInicio != null && _dataFim != null) {
        await calcularCustosLavoura(
          lavouraId: lavouraId,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
        );
      } else {
        await calcularCustosUltimoMes(lavouraId);
      }

      _isUpdating = false;
      notifyListeners();
    } catch (e) {
      _isUpdating = false;
      _errorUpdate = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 🧹 LIMPAR ESTADOS DE ERRO
  void limparErros() {
    _errorCustos = null;
    _errorResumo = null;
    _errorHistorico = null;
    _errorUpdate = null;
    notifyListeners();
  }

  // 🧹 LIMPAR TODOS OS DADOS
  void limparDados() {
    _custoAtual = null;
    _resumoAtual = null;
    _historico.clear();
    _dataInicio = null;
    _dataFim = null;
    limparErros();
  }

  // 🔍 VALIDAR DATAS
  bool validarDatas(DateTime? dataInicio, DateTime? dataFim) {
    if (dataInicio != null && dataFim != null) {
      return dataInicio.isBefore(dataFim);
    }
    return true; // Se não especificadas, são válidas
  }

  // 🧪 TESTAR CONEXÃO
  Future<bool> testarConexao() async {
    try {
      return await _custoService.testarConexao();
    } catch (e) {
      // Log de erro para debug
      return false;
    }
  }

  // 💰 FORMATAR VALOR MONETÁRIO
  String formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // 📅 FORMATAR DATA
  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  // 📅 FORMATAR DATA E HORA
  String formatarDataHora(DateTime data) {
    return '${formatarData(data)} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  // 📊 OBTER CUSTO TOTAL FORMATADO
  String get custoTotalFormatado {
    if (_custoAtual != null) {
      return formatarMoeda(_custoAtual!.custoTotal);
    }
    return 'R\$ 0,00';
  }

  // 📊 OBTER PERCENTUAL DE CADA CATEGORIA
  double getPercentualCategoria(double valorCategoria) {
    if (_custoAtual != null && _custoAtual!.custoTotal > 0) {
      return (valorCategoria / _custoAtual!.custoTotal) * 100;
    }
    return 0.0;
  }

  // 📊 OBTER COR PARA CATEGORIA
  Color getCorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'aplicação de agrotóxico':
        return Colors.orange;
      case 'aplicação de insumo':
        return Colors.blue;
      case 'movimentação de estoque':
        return Colors.green;
      case 'plantio':
        return Colors.purple;
      case 'colheita':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // 📊 OBTER ICONE PARA CATEGORIA
  IconData getIconeCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'aplicação de agrotóxico':
        return Icons.science;
      case 'aplicação de insumo':
        return Icons.eco;
      case 'movimentação de estoque':
        return Icons.inventory;
      case 'plantio':
        return Icons.local_florist;
      case 'colheita':
        return Icons.agriculture;
      default:
        return Icons.attach_money;
    }
  }
}
