import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/RendimentoColheitaModel.dart';
import '../../models/ColheitaModel.dart';
import '../../repositories/ColheitaRepo.dart';
import '../services/viewmodel_manager.dart';

class ColheitaViewModel extends RefreshableViewModel {
  final ColheitaRepo _repository = ColheitaRepo();
  List<ColheitaModel> _colheita = [];
  bool isLoading = false;
  String? errorMessage;

  RendimentoColheitaModel? rendimento;

  List<ColheitaModel> get colheita => _colheita;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _colheita = await _repository.getAll();
    } catch (e) {
      _colheita = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ColheitaModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.create(model);
      await fetchByLavoura(model.lavouraID);
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      debugPrint(errorMessage);
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(ColheitaModel model) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.update(model);
      await fetchByLavoura(model.lavouraID);
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

  @override
  void clearData() {
    _colheita = [];
    rendimento = null;
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  Future<void> fetchByLavoura(int lavouraId) async {
    try {
      isLoading = true;
      notifyListeners();

      _colheita = await _repository.fetchByLavoura(lavouraId);
    } catch (e) {
      print('Erro ao buscar colheita da lavoura: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarRendimento(int lavouraId) async {
    try {
      rendimento = await _repository.getRendimentoPorLavoura(lavouraId);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro ao carregar rendimento: $e';
      notifyListeners();
    }
  }
}

