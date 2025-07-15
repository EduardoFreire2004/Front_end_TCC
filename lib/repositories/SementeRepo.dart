import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/SementeModel.dart';
import '../services/api_service.dart';

class SementeRepo {
  Future<List<SementeModel>> getAll() async {
    try {
      final response = await ApiService.get('/Sementes');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => SementeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}: Não foi possível carregar os sementes.');
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

  Future<void> create(SementeModel semente) async {
    try {
      final response = await ApiService.post(
        '/Sementes',
        jsonEncode(semente.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar semente (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar semente: $e');
    }
  }

  Future<void> update(SementeModel semente) async {
    try {
      final response = await ApiService.put(
        '/Sementes/${semente.id}',
        jsonEncode(semente.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar semente (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar semente: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Sementes/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar semente (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar semente: $e');
    }
  }

   Future<SementeModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/Sementes/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return SementeModel.fromJson(jsonMap);
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
