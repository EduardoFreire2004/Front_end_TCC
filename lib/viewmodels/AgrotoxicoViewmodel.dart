import 'package:flutter/material.dart';
import '../repositories/ForneAgrotoxicoRepo.dart';
import '../repositories/TipoAgrotoxicoRepo.dart';
import '../repositories/AgrotoxicoRepo.dart';
import '../models/AgrotoxicoModel.dart';
import '../models/ForneAgrotoxicoModel.dart';
import '../models/TipoAgrotoxicoModel.dart';

class AgrotoxicoViewModel extends ChangeNotifier {
  final ForneAgrotoxicoRepo forneRepo = ForneAgrotoxicoRepo();
  final TipoAgrotoxicoRepo tipoRepo = TipoAgrotoxicoRepo();
  final AgrotoxicoRepo agrotoxicoRepo = AgrotoxicoRepo();

  List<AgrotoxicoModel> _agrotoxico = [];
  List<ForneAgrotoxicoModel> fornecedores = [];
  List<TipoAgrotoxicoModel> tipos = [];

  bool carregando = false;

  Future<void> buscarFornecedores(String nome) async {
    carregando = true;
    notifyListeners();

    try {
      fornecedores = await forneRepo.buscarPorNome(nome);
    } catch (e) {
      fornecedores = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> loadAgrotoxico() async {
    _agrotoxico = await agrotoxicoRepo.getAll();
    notifyListeners();
  }

  Future<void> buscarTipos(String descricao) async {
    carregando = true;
    notifyListeners();

    try {
      tipos = await tipoRepo.buscarPorDescricao(descricao);
    } catch (e) {
      tipos = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarAgrotoxico(AgrotoxicoModel agrotoxico) async {
    await agrotoxicoRepo.create(agrotoxico);
    await loadAgrotoxico();
  }

  Future<void> cadastrarFornecedor(ForneAgrotoxicoModel fornecedor) async {
    await forneRepo.create(fornecedor);
  }

  Future<void> cadastrarTipo(TipoAgrotoxicoModel tipo) async {
    await tipoRepo.create(tipo);
  }
}
