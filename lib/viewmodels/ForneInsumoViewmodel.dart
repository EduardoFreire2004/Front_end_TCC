import 'package:flutter/material.dart';
import '../models/ForneInsumoModel.dart';
import '../repositories/ForneInsumoRepo.dart';

class ForneInsumoViewmodel extends ChangeNotifier {
  final ForneInsumoRepo _repository = ForneInsumoRepo();
  List<ForneInsumoModel> _forneInsumo = [];

  List<ForneInsumoModel> get forneInsumo => _forneInsumo;

  Future<void> loadForneInsumo() async {
    _forneInsumo = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addForneInsumo(ForneInsumoModel nova) async {
    await _repository.create(nova);
    await loadForneInsumo();
  }

  Future<void> updateForneInsumo(ForneInsumoModel nova) async {
    await _repository.update(nova);
    await loadForneInsumo();
  }

  Future<void> deleteForneInsumo(int id) async {
    await _repository.delete(id);
    await loadForneInsumo();
  }
}
