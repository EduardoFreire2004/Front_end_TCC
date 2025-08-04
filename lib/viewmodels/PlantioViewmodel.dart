import 'package:flutter/material.dart';
import '../../models/PlantioModel.dart';
import '../../repositories/PlantioRepo.dart';

class PlantioViewModel extends ChangeNotifier {
  final PlantioRepo _repository = PlantioRepo();
  List<PlantioModel> _plantio = [];
  bool isLoading = false;
  String? errorMessage;

  List<PlantioModel> get plantio => _plantio;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _plantio = await _repository.getAll();
    } catch (e) {
      _plantio = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(PlantioModel model) async {
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

  Future<void> update(PlantioModel model) async {
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

  Future<void> delete(int id, int lavouraId) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetchByLavoura(lavouraId);
    } catch (e) {
      errorMessage = 'Erro ao excluir: $e';
      debugPrint(errorMessage);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByLavoura(int lavouraId) async {
    try {
      isLoading = true;
      notifyListeners();

      _plantio = await _repository.fetchByLavoura(lavouraId);
    } catch (e) {
      print('Erro ao buscar plantio da lavoura: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
