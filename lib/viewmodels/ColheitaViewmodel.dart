import 'package:flutter/material.dart';
import '../models/ColheitaModel.dart';
import '../repositories/ColheitaRepo.dart';

class ColheitaViewmodel extends ChangeNotifier {
  final ColheitaRepo _repository = ColheitaRepo();
  List<ColheitaModel> _colheita = [];

  List<ColheitaModel> get colheita => _colheita;

  Future<void> loadColheita() async {
    _colheita = await _repository.getAll();
    notifyListeners();
  }

  Future<void> addColheita(ColheitaModel nova) async {
    await _repository.create(nova);
    await loadColheita();
  }

  Future<void> updateColheita(ColheitaModel nova) async {
    await _repository.update(nova);
    await loadColheita();
  }

  Future<void> deleteColheita(int id) async {
    await _repository.delete(id);
    await loadColheita();
  }
}
