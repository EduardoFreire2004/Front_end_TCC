import 'package:flutter/material.dart';
import '../models/ForneAgrotoxicoModel.dart';
import '../repositories/ForneAgrotoxicoRepo.dart';

class ForneAgrotoxicoViewmodel extends ChangeNotifier {
  final ForneAgrotoxicoRepo _repository = ForneAgrotoxicoRepo();
  List<ForneAgrotoxicoModel> _forneAgrotoxico = [];

  List<ForneAgrotoxicoModel> get forneAgrotoxico => _forneAgrotoxico;

  Future<void> loadForneAgrotoxico() async {
    _forneAgrotoxico = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addForneAgrotoxico(ForneAgrotoxicoModel nova) async {
    await _repository.create(nova);
    await loadForneAgrotoxico();
  }

  Future<void> updateForneAgrotoxico(ForneAgrotoxicoModel nova) async {
    await _repository.update(nova);
    await loadForneAgrotoxico();
  }

  Future<void> deleteForneAgrotoxico(int id) async {
    await _repository.delete(id);
    await loadForneAgrotoxico();
  }

  Future<void> buscarPorNome(String nome) async {
  _forneAgrotoxico = await _repository.buscarPorNome(nome);
  notifyListeners();
}

}
