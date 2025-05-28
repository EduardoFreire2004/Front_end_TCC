import 'dart:convert';
import '../models/AgrotoxicoModel.dart';
import '../services/api_service.dart';

class AgrotoxicoRepo {
  Future<List<AgrotoxicoModel>> getAll() async {
    final response = await ApiService.get('/Agrotoxicos');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => AgrotoxicoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Agrotoxico');
    }
  }

  Future<void> create(AgrotoxicoModel agrotoxico) async {
    await ApiService.post(
      '/Agrotoxicos',
      jsonEncode(agrotoxico.toJson()),
    );
  }

  Future<void> update(AgrotoxicoModel agrotoxico) async {
    await ApiService.put(
      '/Agrotoxicos/${agrotoxico.id}',
      jsonEncode(agrotoxico.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Agrotoxicos/$id');
  }
}
