import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ForneSementeModel.dart';
import '../repositories/ForneSementeRepo.dart';

class ForneInsumoViewmodel extends ChangeNotifier {
  final ForneSementeRepo _repository = ForneSementeRepo();
  List<ForneSementeModel> _forneSemente = [];

  List<ForneSementeModel> get forneSemente => _forneSemente;

  Future<void> loadForneSemente() async {
    _forneSemente = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addForneSemente(ForneSementeModel nova) async {
    await _repository.create(nova);
    await loadForneSemente();
  }

  Future<void> updateColheita(ForneSementeModel nova) async {
    await _repository.update(nova);
    await loadForneSemente();
  }

  Future<void> deleteForneSemente(int id) async {
    await _repository.delete(id);
    await loadForneSemente();
  }
}
