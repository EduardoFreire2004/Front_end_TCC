import 'package:flutter/material.dart';
import '../../models/AgrotoxicoModel.dart';
import '../../repositories/AgrotoxicoRepo.dart';

class AgrotoxicoViewModel extends ChangeNotifier {
  final AgrotoxicoRepo _repository = AgrotoxicoRepo();
  List<AgrotoxicoModel> _lista = [];
  bool isLoading = false;
  String? errorMessage;

  List<AgrotoxicoModel> get lista => _lista;

  Future<void> fetch() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _lista = await _repository.getAll();
    } catch (e) {
      _lista = [];
      errorMessage = e.toString();
      debugPrint('Erro em fetch(): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(AgrotoxicoModel model) async {
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

  Future<void> update(AgrotoxicoModel model) async {
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

  Future<AgrotoxicoModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final agrotoxico = await _repository.getID(id);
      return agrotoxico;
    } catch (e) {
      errorMessage = 'Erro ao buscar agrotóxico: $e';
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

      _lista = await _repository.getByNome(nome);
    } catch (e) {
      _lista = [];
      print('Erro ao buscar: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
