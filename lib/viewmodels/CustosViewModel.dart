import 'package:flutter/material.dart';
import '../../models/CustosModel.dart';
import '../../repositories/CustosRepo.dart';
import '../services/viewmodel_manager.dart';

class CustoViewModel extends RefreshableViewModel {
  final CustoRepo _repository = CustoRepo();

  List<CustoModel> _custos = [];
  bool isLoading = false;
  String? errorMessage;

  List<CustoModel> get custos => _custos;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _custos = await _repository.getAll();
    } catch (e) {
      _custos = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByLavoura(int lavouraId) async {
    isLoading = true;
    notifyListeners();

    try {
      _custos = await _repository.fetchByLavoura(lavouraId);
    } catch (e) {
      _custos = [];
      errorMessage = 'Erro ao buscar custos por lavoura: $e';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(CustoModel model) async {
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

  Future<void> update(CustoModel model) async {
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

  @override
  void clearData() {
    _custos = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  // Método para recarregar dados após login
  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<void> delete(int id, int lavouraId) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetchByLavoura(lavouraId);
    } catch (e) {
      errorMessage = 'Erro ao excluir: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
