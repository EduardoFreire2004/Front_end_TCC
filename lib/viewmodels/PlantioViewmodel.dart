import 'package:flutter/material.dart';
import '../../models/PlantioModel.dart';
import '../../repositories/PlantioRepo.dart';

class PlantioViewModel extends ChangeNotifier {
  final PlantioRepo _repository = PlantioRepo();
  List<PlantioModel> _plantio = [];
  bool isLoading = false;

  List<PlantioModel> get plantio => _plantio;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _plantio = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(PlantioModel model) async {
    await _repository.create(model);
    await fetch();
  }

  Future<void> update(PlantioModel model) async {
    await _repository.update(model);
    await fetch();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
