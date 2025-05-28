import 'package:flutter/material.dart';
import '../models/ColheitaModel.dart';
import '../repositories/ColheitaRepo.dart';

class ColheitaViewmodel extends ChangeNotifier {
  final ColheitaRepo _repository = ColheitaRepo();
  List<ColheitaModel> _colheita = [];
  bool _isLoading = false;

  List<ColheitaModel> get colheita => _colheita;
  bool get isLoading => _isLoading;

  Future<void> loadColheita() async {
    _isLoading = true;
    notifyListeners();

    try {
      _colheita = await _repository.getAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addColheita(ColheitaModel nova) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.create(nova);
      await loadColheita();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateColheita(ColheitaModel nova) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.update(nova);
      await loadColheita();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteColheita(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await loadColheita();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
