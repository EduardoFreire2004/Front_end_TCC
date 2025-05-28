import 'package:flutter/material.dart';
import '../../models/ForneAgrotoxicoModel.dart';
import '../../repositories/ForneAgrotoxicoRepo.dart';

class FornecedorAgrotoxicoViewModel extends ChangeNotifier {
  final ForneAgrotoxicoRepo _repository = ForneAgrotoxicoRepo();

  List<ForneAgrotoxicoModel> _fornecedores = [];
  bool isLoading = false;

  List<ForneAgrotoxicoModel> get fornecedores => _fornecedores;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _fornecedores = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addFornecedor(ForneAgrotoxicoModel fornecedor) async {
    await _repository.create(fornecedor);
    await fetch();
  }

  Future<void> updateFornecedor(ForneAgrotoxicoModel fornecedor) async {
    await _repository.update(fornecedor);
    await fetch();
  }

  Future<void> deleteFornecedor(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
