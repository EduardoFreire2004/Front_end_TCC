import 'dart:convert';
import '../models/TipoAgrotoxicoModel.dart';
import '../services/api_service.dart';

class TipoAgrotoxicoRepo {
  Future<List<TipoAgrotoxicoModel>> getAll() async {
    final response = await ApiService.get('/TipoAgrotoxicos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (item) =>
                TipoAgrotoxicoModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Erro ao carregar o tipo de agrotoxicos');
    }
  }

  Future<List<TipoAgrotoxicoModel>> buscarPorDescricao(String descricao) async {
    final response = await ApiService.get('/TipoAgrotoxicos?nome=$descricao');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (item) =>
                TipoAgrotoxicoModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Erro ao buscar tipo pelo nome');
    }
  }

  Future<void> create(TipoAgrotoxicoModel TipoAgrotoxico) async {
    await ApiService.post(
      '/TipoAgrotoxicos',
      jsonEncode(TipoAgrotoxico.toJsonForCreate()),
    );
  }

  Future<void> update(TipoAgrotoxicoModel TipoAgrotoxicos) async {
    await ApiService.put(
      '/TipoAgrotoxicos/${TipoAgrotoxicos.id}',
      jsonEncode(TipoAgrotoxicos.toJsonForUpdate()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/TipoAgrotoxicos/$id');
  }
}
