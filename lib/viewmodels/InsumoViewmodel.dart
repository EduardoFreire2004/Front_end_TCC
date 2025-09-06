import 'package:flutter/material.dart';
import '../../models/InsumoModel.dart';
import '../../repositories/InsumoRepo.dart';
import '../services/viewmodel_manager.dart';

class InsumoViewModel extends RefreshableViewModel {
  final InsumoRepo _repository = InsumoRepo();
  List<InsumoModel> _insumo = [];
  bool isLoading = false;
  String? errorMessage;

  List<InsumoModel> get insumo => _insumo;

  Future<bool> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _insumo = await _repository.getAll();
      return true;
    } catch (e) {
      _insumo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(InsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.create(model);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(InsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.update(model);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao atualizar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao excluir: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void clearData() {
    _insumo = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  // Método para recarregar dados após login
  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<InsumoModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final insumo = await _repository.getID(id);
      return insumo;
    } catch (e) {
      errorMessage = 'Erro ao buscar insumo: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchByNome(String nome) async {
    try {
      isLoading = true;
      notifyListeners();

      _insumo = await _repository.getByNome(nome);
      return true;
    } catch (e) {
      _insumo = [];
      print('Erro ao buscar: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
