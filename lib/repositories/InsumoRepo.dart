import 'dart:convert';
import '../models/InsumoModel.dart';
import '../services/api_service.dart';

class InsumoRepo {
  Future<List<InsumoModel>> getAll() async {
    final response = await ApiService.get('/Insumos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => InsumoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Insumo');
    }
  }

  Future<void> create(InsumoModel insumo) async {
    await ApiService.post(
      '/Insumos',
      jsonEncode(insumo.toJson()),
    );
  }

  Future<void> update(InsumoModel insumo) async {
    await ApiService.put(
      '/Insumos/${insumo.id}',
      jsonEncode(insumo.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Insumos/$id');
  }
}
