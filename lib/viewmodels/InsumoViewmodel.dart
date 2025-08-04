import 'package:flutter/material.dart';
import '../../models/InsumoModel.dart';
import '../../repositories/InsumoRepo.dart';

class InsumoViewModel extends ChangeNotifier {
  final InsumoRepo _repository = InsumoRepo();
  List<InsumoModel> _insumo = [];
  bool isLoading = false;
  String? errorMessage;

  List<InsumoModel> get insumo => _insumo;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _insumo = await _repository.getAll();
    } catch (e) {
      _insumo = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(InsumoModel model) async {
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

  Future<void> update(InsumoModel model) async {
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

  Future<void> fetchByNome(String nome) async {
    try {
      isLoading = true;
      notifyListeners();

      _insumo = await _repository.getByNome(nome);
    } catch (e) {
      _insumo = [];
      print('Erro ao buscar: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
