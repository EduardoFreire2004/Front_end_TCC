import 'package:flutter/material.dart';
import '../../models/SementeModel.dart';
import '../../repositories/SementeRepo.dart';

class SementeViewModel extends ChangeNotifier {
  final SementeRepo _repository = SementeRepo();
  List<SementeModel> _semente = [];
  bool isLoading = false;

  List<SementeModel> get semente => _semente;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _semente = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(SementeModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(SementeModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
