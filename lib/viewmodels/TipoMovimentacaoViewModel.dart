import 'package:flutter/material.dart';
import '../../models/TipoMovimentacaoModel.dart';
import '../../repositories/TipoMovimentacaoRepo.dart';

class TipoMovimetacaoViewModel extends ChangeNotifier {
  final TipoMovimentacaoRepo _repository = TipoMovimentacaoRepo();
  List<TipoMovimentacaoModel> _tipo = [];
  bool isLoading = false;
  String? errorMessage;

  List<TipoMovimentacaoModel> get tipo => _tipo;

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

  Future<void> add(TipoMovimentacaoModel model) async {
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

  Future<void> update(TipoMovimentacaoModel model) async {
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
}
