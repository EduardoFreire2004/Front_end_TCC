import 'package:flutter/material.dart';
import '../../models/AgrotoxicoModel.dart';
import '../../repositories/AgrotoxicoRepo.dart';
import '../services/viewmodel_manager.dart';

class AgrotoxicoViewModel extends RefreshableViewModel {
  final AgrotoxicoRepo _repository = AgrotoxicoRepo();
  List<AgrotoxicoModel> _lista = [];
  bool isLoading = false;
  String? errorMessage;

  List<AgrotoxicoModel> get lista => _lista;

  Future<bool> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _lista = await _repository.getAll();
      return true;
    } catch (e) {
      _lista = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(AgrotoxicoModel model) async {
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

  Future<bool> update(AgrotoxicoModel model) async {
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
    _lista = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  // Método para recarregar dados após login
  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<AgrotoxicoModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final agrotoxico = await _repository.getID(id);
      return agrotoxico;
    } catch (e) {
      errorMessage = 'Erro ao buscar agrotóxico: $e';
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

      _lista = await _repository.getByNome(nome);
      return true;
    } catch (e) {
      _lista = [];
      print('Erro ao buscar: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
