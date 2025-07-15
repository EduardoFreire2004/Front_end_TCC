import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/ForneSementeModel.dart';
import '../services/api_service.dart';

class ForneSementeRepo {
  Future<List<ForneSementeModel>> getAll() async {
    try {
      final response = await ApiService.get('/FornecedorSementes');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => ForneSementeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}: Não foi possível carregar os fornecedores.');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw Exception('Tempo de resposta da API excedido.');
    } on FormatException {
      throw Exception('Erro ao interpretar os dados recebidos.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> create(ForneSementeModel fornecedor) async {
    try {
      final response = await ApiService.post(
        '/FornecedorSementes',
        jsonEncode(fornecedor.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar fornecedor (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar fornecedor: $e');
    }
  }

  Future<void> update(ForneSementeModel fornecedor) async {
    try {
      final response = await ApiService.put(
        '/FornecedorSementes/${fornecedor.id}',
        jsonEncode(fornecedor.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar fornecedor (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar fornecedor: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/FornecedorSementes/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar fornecedor (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar fornecedor: $e');
    }
  }

  Future<ForneSementeModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/FornecedorAgrotoxicos/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return ForneSementeModel.fromJson(jsonMap);
        } else {
          throw Exception('Resposta vazia do servidor');
        }
      } else {
        throw Exception('Erro ao buscar semente (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Falha de conexão. Verifique sua internet');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido');
    } catch (e) {
      throw Exception('Erro ao buscar tipo: $e');
    }
  }
}
