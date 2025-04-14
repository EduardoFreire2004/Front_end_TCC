import 'dart:convert';
import '../models/ForneInsumoModel.dart';
import '../services/api_service.dart';

class ForneInsumoRepo {

  Future<List<ForneInsumoModel>> getAll() async {
    final response = await ApiService.get('/FornecedorInsumos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ForneInsumoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar fornecedor de insumos');
    }
  }

  Future<void> create(ForneInsumoModel forneInsumo) async {
    await ApiService.post('/FornecedorInsumos', jsonEncode(forneInsumo.toJson()));
  }

  Future<void> update(ForneInsumoModel forneInsumo) async {
    await ApiService.put(
      '/FornecedorInsumos/${forneInsumo.id}',
      jsonEncode(forneInsumo.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/FornecedorInsumos/$id');
  }
}
