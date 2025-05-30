import 'dart:convert';
import '../models/PlantioModel.dart';
import '../services/api_service.dart';

class PlantioRepo {
  Future<List<PlantioModel>> getAll() async {
    final response = await ApiService.get('/Plantios');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => PlantioModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Plantio');
    }
  }

  Future<void> create(PlantioModel plantio) async {
    await ApiService.post(
      '/Plantios',
      jsonEncode(plantio.toJson()),
    );
  }

  Future<void> update(PlantioModel plantio) async {
    await ApiService.put(
      '/Plantios/${plantio.id}',
      jsonEncode(plantio.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Plantios/$id');
  }
}
