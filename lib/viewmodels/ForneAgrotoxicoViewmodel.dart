import 'package:flutter/material.dart';
import '../../models/ForneAgrotoxicoModel.dart';
import '../../repositories/ForneAgrotoxicoRepo.dart';

class ForneAgrotoxicoViewModel extends ChangeNotifier {
  final ForneAgrotoxicoRepo _repository = ForneAgrotoxicoRepo();
  List<ForneAgrotoxicoModel> _forneAgrotoxico = [];
  bool isLoading = false;
  String? errorMessage;

  List<ForneAgrotoxicoModel> get forneAgrotoxico => _forneAgrotoxico;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _forneAgrotoxico = await _repository.getAll();
    } catch (e) {
      _forneAgrotoxico = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ForneAgrotoxicoModel model) async {
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

  Future<void> update(ForneAgrotoxicoModel model) async {
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

  Future<ForneAgrotoxicoModel?> getID(int id) async {
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

      _forneAgrotoxico = await _repository.getByParametro(tipo, valor);
    } catch (e) {
      _forneAgrotoxico = [];
      print('Erro ao buscar: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
