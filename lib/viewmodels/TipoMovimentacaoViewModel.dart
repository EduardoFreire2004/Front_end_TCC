import 'package:flutter/material.dart';
import '../models/TipoMovimentacaoModel.dart';
import '../repositories/TipoMovimentacaoRepo.dart';

class TipoMovimentacaoViewmodel extends ChangeNotifier {
  final TipoMovimentacaoRepo _repository = TipoMovimentacaoRepo();
  List<TipoMovimentacaoModel> _tipoMovimentacao = [];

  List<TipoMovimentacaoModel> get tipoMovimentacao => _tipoMovimentacao;

  Future<void> loadTipoMovimentacao() async {
    _tipoMovimentacao = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addTipoMovimentacao(TipoMovimentacaoModel nova) async {
    await _repository.create(nova);
    await loadTipoMovimentacao();
  }

  Future<void> updateTipoMovimentacao(TipoMovimentacaoModel nova) async {
    await _repository.update(nova);
    await loadTipoMovimentacao();
  }

  Future<void> deleteTipoMovimentacao(int id) async {
    await _repository.delete(id);
    await loadTipoMovimentacao();
  }
}
