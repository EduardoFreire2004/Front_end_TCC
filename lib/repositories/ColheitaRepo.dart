import 'dart:convert';
import '../models/ColheitaModel.dart';
import '../services/api_service.dart';

class ColheitaRepo {

  Future<List<ColheitaModel>> getAll() async {
    final response = await ApiService.get('/Colheitas');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ColheitaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar colheitas');
    }
  }

  Future<void> create(ColheitaModel colheita) async {
    await ApiService.post('/Colheitas', jsonEncode(colheita.toJson()));
  }

  Future<void> update(ColheitaModel colheita) async {
    await ApiService.put(
      '/Colheitas/${colheita.id}',
      jsonEncode(colheita.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/Colheitas/$id');
  }
}
