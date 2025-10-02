import 'package:flutter/material.dart';
import '../../models/CategoriaInsumoModel.dart';
import '../../repositories/CategoriaInsumoRepo.dart';
import '../services/viewmodel_manager.dart';

class CategoriaInsumoViewModel extends RefreshableViewModel {
  final CategoriaInsumoRepo _repository = CategoriaInsumoRepo();
  List<CategoriaInsumoModel> _categoriaInsumo = [];
  bool isLoading = false;
  String? errorMessage;

  List<CategoriaInsumoModel> get categoriaInsumo => _categoriaInsumo;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _categoriaInsumo = await _repository.getAll();
    } catch (e) {
      _categoriaInsumo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(CategoriaInsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.create(model);
      await fetch(); 
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow; 
    }
  }

  Future<void> update(CategoriaInsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.update(model);
      await fetch();
    } catch (e) {
      errorMessage = 'Erro ao atualizar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetch();
    } catch (e) {
      errorMessage = 'Erro ao excluir: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void clearData() {
    _categoriaInsumo = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<CategoriaInsumoModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final fornecedor = await _repository.getID(id);
      return fornecedor;
    } catch (e) {
      errorMessage = 'Erro ao buscar Categoria do Insumo: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

