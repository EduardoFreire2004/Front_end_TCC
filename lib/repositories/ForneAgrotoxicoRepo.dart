import 'dart:convert';
import '../models/ForneAgrotoxicoModel.dart';
import '../services/api_service.dart';

class ForneAgrotoxicoRepo {

  Future<List<ForneAgrotoxicoModel>> getAll() async {
    final response = await ApiService.get('/FornecedorAgrotoxicos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ForneAgrotoxicoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar fornecedor de agrotoxicos');
    }
  }

  Future<List<ForneAgrotoxicoModel>> buscarPorNome(String nome) async {
  final response = await ApiService.get('/FornecedorAgrotoxicos?nome=$nome');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ForneAgrotoxicoModel.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Erro ao buscar fornecedor pelo nome');
    }
  }

  Future<void> create(ForneAgrotoxicoModel forneAgrotoxico) async {
    await ApiService.post('/FornecedorAgrotoxicos', jsonEncode(forneAgrotoxico.toJsonForCreate()));
  }

  Future<void> update(ForneAgrotoxicoModel forneAgrotoxicos) async {
    await ApiService.put(
      '/FornecedorAgrotoxicos/${forneAgrotoxicos.id}',
      jsonEncode(forneAgrotoxicos.toJsonForUpdate()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/FornecedorAgrotoxicos/$id');
  }
}
