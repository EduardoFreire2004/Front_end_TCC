import 'package:flutter/material.dart';
import '../models/ColheitaModel.dart';
import '../repositories/ColheitaRepo.dart';

class ColheitaViewmodel extends ChangeNotifier {
  final ColheitaRepo _repository = ColheitaRepo();
  List<ColheitaModel> _colheita = [];
  bool _isLoading = false;

  List<ColheitaModel> get colheita => _colheita;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      _colheita = await _repository.getAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ColheitaModel nova) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.create(nova);
      await fetch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(ColheitaModel nova) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.update(nova);
      await fetch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.delete(id);
      await fetch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
