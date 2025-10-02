import 'package:flutter/material.dart';
import '../../models/LavouraModel.dart';
import '../../repositories/LavouraRepo.dart';
import '../services/viewmodel_manager.dart';

class LavouraViewModel extends RefreshableViewModel {
  final LavouraRepo _repository = LavouraRepo();
  List<LavouraModel> _lavoura = [];
  bool isLoading = false;
  String? errorMessage;

  List<LavouraModel> get lavoura => _lavoura;

  Future<bool> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _lavoura = await _repository.getAll();
      return true;
    } catch (e) {
      _lavoura = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(LavouraModel model) async {
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

  Future<bool> update(LavouraModel model) async {
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
    _lavoura = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<bool> fetchByNome(String nome) async {
    try {
      isLoading = true;
      notifyListeners();

      _lavoura = await _repository.getByNome(nome);
      return true;
    } catch (e) {
      _lavoura = [];
      print('Erro ao buscar: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<LavouraModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final lavoura = await _repository.getID(id);
      return lavoura;
    } catch (e) {
      errorMessage = 'Erro ao buscar lavoura: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

