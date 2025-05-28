import 'package:flutter/material.dart';
import '../../models/AgrotoxicoModel.dart';
import '../../repositories/AgrotoxicoRepo.dart';

class AgrotoxicoViewModel extends ChangeNotifier {
  final AgrotoxicoRepo _repository = AgrotoxicoRepo();
  List<AgrotoxicoModel> _lista = [];
  bool isLoading = false;

  List<AgrotoxicoModel> get lista => _lista;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _lista = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(AgrotoxicoModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(AgrotoxicoModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
