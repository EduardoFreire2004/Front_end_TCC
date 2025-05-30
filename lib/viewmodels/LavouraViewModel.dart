import 'package:flutter/material.dart';
import '../../models/LavouraModel.dart';
import '../../repositories/LavouraRepo.dart';

class LavouraViewModel extends ChangeNotifier {
  final LavouraRepo _repository = LavouraRepo();
  List<LavouraModel> _lavoura = [];
  bool isLoading = false;

  List<LavouraModel> get lavoura => _lavoura;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _lavoura = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(LavouraModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(LavouraModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
