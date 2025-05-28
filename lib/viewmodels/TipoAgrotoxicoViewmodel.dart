import 'package:flutter/material.dart';
import '../models/TipoAgrotoxicoModel.dart';
import '../repositories/TipoAgrotoxicoRepo.dart';

class TipoAgrotoxicoViewModel extends ChangeNotifier {
  final TipoAgrotoxicoRepo _repository = TipoAgrotoxicoRepo();

  List<TipoAgrotoxicoModel> _tipos = [];
  bool isLoading = false;

  List<TipoAgrotoxicoModel> get tipos => _tipos;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    _tipos = await _repository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTipo(TipoAgrotoxicoModel tipo) async {
    await _repository.create(tipo);
    await fetch();
  }

  Future<void> updateTipo(TipoAgrotoxicoModel tipo) async {
    await _repository.update(tipo);
    await fetch();
  }

  Future<void> deleteTipo(int id) async {
    await _repository.delete(id);
    await fetch();
  }
}
