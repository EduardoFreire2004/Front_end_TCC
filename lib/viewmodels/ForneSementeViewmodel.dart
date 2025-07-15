import 'package:flutter/material.dart';
import '../../models/ForneSementeModel.dart';
import '../../repositories/ForneSementeRepo.dart';

class ForneSementeViewModel extends ChangeNotifier {
  final ForneSementeRepo _repository = ForneSementeRepo();
  List<ForneSementeModel> _forneSemente = [];
  bool isLoading = false;
  String? errorMessage;

  List<ForneSementeModel> get forneSemente => _forneSemente;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _forneSemente = await _repository.getAll();
    } catch (e) {
      _forneSemente = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ForneSementeModel model) async {
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

  Future<void> update(ForneSementeModel model) async {
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

  Future<ForneSementeModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final fornecedor = await _repository.getID(id);
      return fornecedor;
    } catch (e) {
      errorMessage = 'Erro ao buscar fornecedor: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
