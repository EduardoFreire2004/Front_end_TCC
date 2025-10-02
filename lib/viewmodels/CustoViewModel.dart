import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/CustoCalculadoModel.dart';
import 'package:flutter_fgl_1/models/ResumoCustosModel.dart';
import 'package:flutter_fgl_1/models/HistoricoCustoModel.dart';
import 'package:flutter_fgl_1/services/custo_service.dart';

class CustoViewModel extends ChangeNotifier {
  final CustoService _custoService;

  CustoCalculadoModel? _custoAtual;
  ResumoCustosModel? _resumoAtual;
  List<HistoricoCustoModel> _historico = [];

  bool _isLoadingCustos = false;
  bool _isLoadingResumo = false;
  bool _isLoadingHistorico = false;
  bool _isUpdating = false;

  String? _errorCustos;
  String? _errorResumo;
  String? _errorHistorico;
  String? _errorUpdate;

  DateTime? _dataInicio;
  DateTime? _dataFim;

  CustoViewModel(this._custoService);

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

  Future<void> calcularCustosUltimoMes(int lavouraId) async {
    try {
      _isLoadingCustos = true;
      _errorCustos = null;
      notifyListeners();

      _custoAtual = await _custoService.calcularCustosUltimoMes(lavouraId);

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

  Future<void> atualizarCustosLavoura(int lavouraId) async {
    try {
      _isUpdating = true;
      _errorUpdate = null;
      notifyListeners();

      await _custoService.atualizarCustosLavoura(lavouraId);

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

  void limparErros() {
    _errorCustos = null;
    _errorResumo = null;
    _errorHistorico = null;
    _errorUpdate = null;
    notifyListeners();
  }

  void limparDados() {
    _custoAtual = null;
    _resumoAtual = null;
    _historico.clear();
    _dataInicio = null;
    _dataFim = null;
    limparErros();
  }

  bool validarDatas(DateTime? dataInicio, DateTime? dataFim) {
    if (dataInicio != null && dataFim != null) {
      return dataInicio.isBefore(dataFim);
    }
    return true; // Se não especificadas, são válidas
  }

  Future<bool> testarConexao() async {
    try {
      return await _custoService.testarConexao();
    } catch (e) {

      return false;
    }
  }

  String formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String formatarDataHora(DateTime data) {
    return '${formatarData(data)} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  String get custoTotalFormatado {
    if (_custoAtual != null) {
      return formatarMoeda(_custoAtual!.custoTotal);
    }
    return 'R\$ 0,00';
  }

  double getPercentualCategoria(double valorCategoria) {
    if (_custoAtual != null && _custoAtual!.custoTotal > 0) {
      return (valorCategoria / _custoAtual!.custoTotal) * 100;
    }
    return 0.0;
  }

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

