import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/repositories/InsumoRepo.dart';
import '../../models/InsumoModel.dart';

class InsumoViewModel extends ChangeNotifier {
  final InsumoRepo _repository = InsumoRepo();
  List<InsumoModel> _insumos = [];
  bool isLoading = false;

  List<InsumoModel> get insumos => _insumos;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _insumos = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(InsumoModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(InsumoModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
