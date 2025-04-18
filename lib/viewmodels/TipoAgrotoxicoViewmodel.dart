import 'package:flutter/material.dart';
import '../models/TipoAgrotoxicoModel.dart';
import '../repositories/TipoAgrotoxicoRepo.dart';

class TipoAgrotoxicoViewmodel extends ChangeNotifier {
  final TipoAgrotoxicoRepo _repository = TipoAgrotoxicoRepo();
  List<TipoAgrotoxicoModel> _tipoAgrotoxico = [];

  List<TipoAgrotoxicoModel> get tipoAgrotoxico => _tipoAgrotoxico;

  Future<void> loadTipoAgrotoxico() async {
    _tipoAgrotoxico = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addTipoAgrotoxico(TipoAgrotoxicoModel nova) async {
    await _repository.create(nova);
    await loadTipoAgrotoxico();
  }

  Future<void> updateTipoAgrotoxico(TipoAgrotoxicoModel nova) async {
    await _repository.update(nova);
    await loadTipoAgrotoxico();
  }

  Future<void> deleteTipoAgrotoxico(int id) async {
    await _repository.delete(id);
    await loadTipoAgrotoxico();
  }

  Future<void> buscarPorDescricao(String descricao) async {
  _tipoAgrotoxico = await _repository.buscarPorDescricao(descricao);
  notifyListeners();
}

}
