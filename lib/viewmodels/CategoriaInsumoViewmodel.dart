import 'package:flutter/material.dart';
import '../../models/CategoriaInsumoModel.dart';
import '../../repositories/CategoriaInsumoRepo.dart';

class CategoriaInsumoViewModel extends ChangeNotifier {
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
}
