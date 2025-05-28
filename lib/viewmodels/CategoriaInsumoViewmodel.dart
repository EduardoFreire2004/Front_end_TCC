import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/repositories/CategoriaInsumoRepo.dart';
import '../../models/CategoriaInsumoModel.dart';

class CategoriaInsumoViewModel extends ChangeNotifier {
  final CategoriaInsumoRepo _repository = CategoriaInsumoRepo();
  List<CategoriaInsumoModel> _categorias = [];
  bool isLoading = false;

  List<CategoriaInsumoModel> get categorias => _categorias;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _categorias = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(CategoriaInsumoModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(CategoriaInsumoModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
