import 'dart:convert';
import '../models/ForneSementeModel.dart';
import '../services/api_service.dart';

class ForneSementeRepo {

  Future<List<ForneSementeModel>> getAll() async {
    final response = await ApiService.get('/FornecedorSementes');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ForneSementeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao carregar fornecedor de sementes');
    }
  }

  Future<void> create(ForneSementeModel forneSemente) async {
    await ApiService.post('/FornecedorSementes', jsonEncode(forneSemente.toJson()));
  }

  Future<void> update(ForneSementeModel forneSemente) async {
    await ApiService.put(
      '/FornecedorSementes/${forneSemente.id}',
      jsonEncode(forneSemente.toJson()),
    );
  }

  Future<void> delete(int id) async {
    await ApiService.delete('/FornecedorSementes/$id');
  }
}
