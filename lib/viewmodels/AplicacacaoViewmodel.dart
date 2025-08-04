import 'package:flutter/material.dart';
import '../../models/AplicacaoModel.dart';
import '../../repositories/AplicacaoRepo.dart';

class AplicacaoViewModel extends ChangeNotifier {
  final AplicacaoRepo _repository = AplicacaoRepo();
  List<AplicacaoModel> _aplicacao = [];
  bool isLoading = false;
  String? errorMessage;

  List<AplicacaoModel> get aplicacao => _aplicacao;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _aplicacao = await _repository.getAll();
    } catch (e) {
      _aplicacao = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(AplicacaoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.create(model);
      await fetchByLavoura(model.lavouraID!);
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(AplicacaoModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.update(model);
      await fetchByLavoura(model.lavouraID!);
    } catch (e) {
      errorMessage = 'Erro ao atualizar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> delete(int id, int lavouraID) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetchByLavoura(lavouraID);
    } catch (e) {
      errorMessage = 'Erro ao excluir: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchByLavoura(int lavouraId) async {
    try {
      isLoading = true;
      notifyListeners();

      _aplicacao = await _repository.fetchByLavoura(lavouraId);
    } catch (e) {
      print('Erro ao buscar aplicações da lavoura: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
