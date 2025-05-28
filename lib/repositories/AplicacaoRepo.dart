import 'dart:convert';
import '../models/AplicacaoModel.dart';
import '../services/api_service.dart';

class AplicacaoRepo {
  Future<List<AplicacaoModel>> getAll() async {
    final response = await ApiService.get('/Aplicacoes');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => AplicacaoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Aplicação');
    }
  }

  Future<void> create(AplicacaoModel aplicacao) async {
    await ApiService.post(
      '/Aplicacoes',
      jsonEncode(aplicacao.toJson()),
    );
  }

  Future<void> update(AplicacaoModel aplicacao) async {
    await ApiService.put(
      '/Aplicacoes/${aplicacao.id}',
      jsonEncode(aplicacao.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Aplicacoes/$id');
  }
}
