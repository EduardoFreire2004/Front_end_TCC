import 'dart:convert';
import '../models/CategoriaInsumoModel.dart';
import '../services/api_service.dart';

class CategoriaInsumoRepo {

  Future<List<CategoriaInsumoModel>> getAll() async {
    final response = await ApiService.get('/CategoriaInsumos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => CategoriaInsumoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar categoria do insumo');
    }
  }

  Future<void> create(CategoriaInsumoModel categoriaInsumo) async {
    await ApiService.post('/CategoriaInsumos', jsonEncode(categoriaInsumo.toJsonForCreate()));
  }

  Future<void> update(CategoriaInsumoModel categoriaInsumo) async {
    await ApiService.put(
      '/CategoriaInsumos/${categoriaInsumo.id}',
      jsonEncode(categoriaInsumo.toJsonForUpdate()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/CategoriaInsumos/$id');
  }
}
