import 'package:flutter/material.dart';
import '../../models/MovimentacaoEstoqueModel.dart';
import '../../repositories/MovimentacaoEstoqueRepo.dart';

class MovimentacaoEstoqueViewModel extends ChangeNotifier {
  final MovimentacaoEstoqueRepo _repo = MovimentacaoEstoqueRepo();
  List<MovimentacaoEstoqueModel> _lista = [];
  bool isLoading = false;
  String? errorMessage;

  List<MovimentacaoEstoqueModel> get lista => _lista;

  Future<bool> fetch() async {
    isLoading = true;
    notifyListeners();
    try {
      _lista = await _repo.getAll();
      return true;
    } catch (e) {
      _lista = [];
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(MovimentacaoEstoqueModel model) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.create(model);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao adicionar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> update(MovimentacaoEstoqueModel model) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.update(model);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao atualizar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> delete(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.delete(id);
      await fetch();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao deletar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchByLavoura(int lavouraId) async {
    isLoading = true;
    notifyListeners();
    try {
      _lista = await _repo.getByLavoura(lavouraId);
      return true;
    } catch (e) {
      _lista = [];
      errorMessage = 'Erro: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<MovimentacaoEstoqueModel?> getID(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final movimentacao = await _repo.getID(id);
      return movimentacao;
    } catch (e) {
      errorMessage = 'Erro ao buscar movimentação: $e';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
