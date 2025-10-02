import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AplicacaoInsumoModel.dart';
import '../../repositories/AplicacaoInsumoRepo.dart';
import '../services/viewmodel_manager.dart';

class AplicacaoInsumoViewModel extends RefreshableViewModel {
  final AplicacaoInsumoRepo _repository = AplicacaoInsumoRepo();
  List<AplicacaoInsumoModel> _aplicacaoInsumo = [];
  bool isLoading = false;
  String? errorMessage;

  List<AplicacaoInsumoModel> get aplicacao => _aplicacaoInsumo;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _aplicacaoInsumo = await _repository.getAll();
    } catch (e) {
      _aplicacaoInsumo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(AplicacaoInsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.create(model);
      await fetchByLavoura(model.lavouraID);
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(AplicacaoInsumoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.update(model);
      await fetchByLavoura(model.lavouraID);
    } catch (e) {
      errorMessage = 'Erro ao atualizar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> delete(int id, int lavouraID) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetchByLavoura(lavouraID);
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
    _aplicacaoInsumo = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<void> fetchByLavoura(int lavouraId) async {
    try {
      isLoading = true;
      notifyListeners();

      _aplicacaoInsumo = await _repository.fetchByLavoura(lavouraId);
    } catch (e) {
      print('Erro ao buscar aplicações da lavoura: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

