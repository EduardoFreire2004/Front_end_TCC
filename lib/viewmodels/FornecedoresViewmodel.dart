import 'package:flutter/material.dart';
import '../../models/FornecedoresModel.dart';
import '../../repositories/FornecedoresRepo.dart';

class FornecedoresViewModel extends ChangeNotifier {
  final FornecedoresRepo _repository = FornecedoresRepo();
  List<FornecedoresModel> _fornecedores = [];
  bool isLoading = false;
  String? errorMessage;

  List<FornecedoresModel> get fornecedores => _fornecedores;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _fornecedores = await _repository.getAll();
    } catch (e) {
      _fornecedores = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(FornecedoresModel model) async {
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

  Future<void> update(FornecedoresModel model) async {
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

  Future<FornecedoresModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final fornecedor = await _repository.getID(id);
      return fornecedor;
    } catch (e) {
      errorMessage = 'Erro ao buscar agrotóxico: $e';
      debugPrint(errorMessage);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByParametro(String tipo, String valor) async {
    try {
      isLoading = true;
      notifyListeners();

      _fornecedores = await _repository.getByParametro(tipo, valor);
    } catch (e) {
      _fornecedores = [];
      print('Erro ao buscar: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
