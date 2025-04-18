import 'package:flutter/material.dart';
import '../models/CategoriaInsumoModel.dart';
import '../repositories/CategoriaInsumoRepo.dart';

class CategoriaInsumoViewmodel extends ChangeNotifier {
  final CategoriaInsumoRepo _repository = CategoriaInsumoRepo();
  List<CategoriaInsumoModel> _categoriaInsumo = [];

  List<CategoriaInsumoModel> get categoriaInsumo => _categoriaInsumo;

  Future<void> loadCategoriaInsumo() async {
    _categoriaInsumo = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addCategoriaInsumo(CategoriaInsumoModel nova) async {
    await _repository.create(nova);
    await loadCategoriaInsumo();
  }

  Future<void> updateCategoriaInsumo(CategoriaInsumoModel nova) async {
    await _repository.update(nova);
    await loadCategoriaInsumo();
  }

  Future<void> deleteCategoriaInsumo(int id) async {
    await _repository.delete(id);
    await loadCategoriaInsumo();
  }
}
