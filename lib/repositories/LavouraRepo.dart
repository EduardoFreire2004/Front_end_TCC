import 'dart:convert';
import '../models/LavouraModel.dart';
import '../services/api_service.dart';

class LavouraRepo {
  Future<List<LavouraModel>> getAll() async {
    final response = await ApiService.get('/Lavouras');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => LavouraModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Lavoura');
    }
  }

  Future<void> create(LavouraModel lavoura) async {
    await ApiService.post(
      '/Lavouras',
      jsonEncode(lavoura.toJson()),
    );
  }

  Future<void> update(LavouraModel lavoura) async {
    await ApiService.put(
      '/Lavouras/${lavoura.id}',
      jsonEncode(lavoura.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Lavouras/$id');
  }
}
