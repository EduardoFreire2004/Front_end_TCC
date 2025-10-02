import 'package:flutter/material.dart';
import '../../models/TipoAgrotoxicoModel.dart';
import '../../repositories/TipoAgrotoxicoRepo.dart';
import '../services/viewmodel_manager.dart';

class TipoAgrotoxicoViewModel extends RefreshableViewModel {
  final TipoAgrotoxicoRepo _repository = TipoAgrotoxicoRepo();
  List<TipoAgrotoxicoModel> _tipo = [];
  bool isLoading = false;
  String? errorMessage;

  List<TipoAgrotoxicoModel> get tipo => _tipo;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _tipo = await _repository.getAll();
    } catch (e) {
      _tipo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(TipoAgrotoxicoModel model) async {
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

  Future<void> update(TipoAgrotoxicoModel model) async {
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
    _tipo = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<TipoAgrotoxicoModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final tipo = await _repository.getID(id);
      return tipo;
    } catch (e) {
      errorMessage = 'Erro ao buscar tipo: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

