import 'package:flutter/material.dart';
import '../../models/SementeModel.dart';
import '../../repositories/SementeRepo.dart';

class SementeViewModel extends ChangeNotifier {
  final SementeRepo _repository = SementeRepo();
  List<SementeModel> _semente = [];
  bool isLoading = false;
  String? errorMessage;

  List<SementeModel> get semente => _semente;

  Future<bool> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _semente = await _repository.getAll();
      return true;
    } catch (e) {
      _semente = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(SementeModel model) async {
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

  Future<bool> update(SementeModel model) async {
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

  Future<SementeModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final fornecedor = await _repository.getID(id);
      return fornecedor;
    } catch (e) {
      errorMessage = 'Erro ao buscar semente: $e';
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

      _semente = await _repository.getByNome(nome);
      return true;
    } catch (e) {
      _semente = [];
      print('Erro ao buscar: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
