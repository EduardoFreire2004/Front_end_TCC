import 'dart:convert';
import '../models/SementeModel.dart';
import '../services/api_service.dart';

class SementeRepo {
  Future<List<SementeModel>> getAll() async {
    final response = await ApiService.get('/Sementes');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => SementeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar Semente');
    }
  }

  Future<void> create(SementeModel semente) async {
    await ApiService.post(
      '/Sementes',
      jsonEncode(semente.toJson()),
    );
  }

  Future<void> update(SementeModel semente) async {
    await ApiService.put(
      '/Sementes/${semente.id}',
      jsonEncode(semente.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Sementes/$id');
  }
}
