import 'package:flutter/material.dart';
import '../../models/AplicacaoModel.dart';
import '../../repositories/AplicacaoRepo.dart';

class AplicacaoViewModel extends ChangeNotifier {
  final AplicacaoRepo _repository = AplicacaoRepo();
  List<AplicacaoModel> _aplicacoes = [];
  bool isLoading = false;

  List<AplicacaoModel> get aplicacoes => _aplicacoes;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _aplicacoes = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(AplicacaoModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(AplicacaoModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
