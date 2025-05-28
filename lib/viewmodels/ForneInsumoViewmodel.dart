import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/repositories/ForneInsumoRepo.dart';
import '../../models/ForneInsumoModel.dart';

class FornecedorInsumoViewModel extends ChangeNotifier {
  final ForneInsumoRepo _repository = ForneInsumoRepo();
  List<ForneInsumoModel> _fornecedores = [];
  bool isLoading = false;

  List<ForneInsumoModel> get fornecedores => _fornecedores;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _fornecedores = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(ForneInsumoModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(ForneInsumoModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
