import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ForneSementeModel.dart';
import 'package:flutter_fgl_1/repositories/ForneSementeRepo.dart';

class FornecedorSementeViewModel extends ChangeNotifier {
  final ForneSementeRepo _repository = ForneSementeRepo();
  List<ForneSementeModel> _sementes = [];
  bool isLoading = false;

  List<ForneSementeModel> get sementes => _sementes;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _sementes = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(ForneSementeModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(ForneSementeModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
