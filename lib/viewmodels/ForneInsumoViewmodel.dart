import 'package:flutter/material.dart';
import '../../models/ForneInsumoModel.dart';
import '../../repositories/ForneInsumoRepo.dart';

class ForneInsumoViewModel extends ChangeNotifier {
  final ForneInsumoRepo _repository = ForneInsumoRepo();
  List<ForneInsumoModel> _forneInsumo = [];
  bool isLoading = false;
  String? errorMessage;

  List<ForneInsumoModel> get forneInsumo => _forneInsumo;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _forneInsumo = await _repository.getAll();
    } catch (e) {
      _forneInsumo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ForneInsumoModel model) async {
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

  Future<void> update(ForneInsumoModel model) async {
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

  Future<ForneInsumoModel?> getID(int id) async {
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

  Future<void> fetchByParametro(String tipo, String valor) async {
    try {
      isLoading = true;
      notifyListeners();

      _forneInsumo = await _repository.getByParametro(tipo, valor);
    } catch (e) {
      _forneInsumo = [];
      print('Erro ao buscar: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
