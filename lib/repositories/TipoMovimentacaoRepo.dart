import 'dart:convert';
import '../models/TipoMovimentacaoModel.dart';
import '../services/api_service.dart';

class TipoMovimentacaoRepo {

  Future<List<TipoMovimentacaoModel>> getAll() async {
    final response = await ApiService.get('/TipoMovimentacoes');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => TipoMovimentacaoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar o tipo de movimentacoes');
    }
  }

  Future<void> create(TipoMovimentacaoModel TipoMovimentacao) async {
    await ApiService.post('/TipoMovimentacoes', jsonEncode(TipoMovimentacao.toJsonForCreate()));
  }

  Future<void> update(TipoMovimentacaoModel TipoMovimentacao) async {
    await ApiService.put(
      '/TipoMovimentacoes/${TipoMovimentacao.id}',
      jsonEncode(TipoMovimentacao.toJsonForUpdate()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/TipoMovimentacoes/$id');
  }
}
