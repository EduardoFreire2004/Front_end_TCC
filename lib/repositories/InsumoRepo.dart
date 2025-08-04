import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/InsumoModel.dart';
import '../services/api_service.dart';

class InsumoRepo {
  Future<List<InsumoModel>> getAll() async {
    try {
      final response = await ApiService.get('/Insumos');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => InsumoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar os insumos.',
        );
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

  Future<void> create(InsumoModel insumo) async {
    try {
      final response = await ApiService.post(
        '/Insumos',
        jsonEncode(insumo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar insumo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar insumo: $e');
    }
  }

  Future<void> update(InsumoModel insumo) async {
    try {
      final response = await ApiService.put(
        '/Insumos/${insumo.id}',
        jsonEncode(insumo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar insumo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar insumo: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Insumos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar insumo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar insumo: $e');
    }
  }

  Future<InsumoModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/Insumos/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return InsumoModel.fromJson(jsonMap);
        } else {
          throw Exception('Resposta vazia do servidor');
        }
      } else {
        throw Exception('Erro ao buscar insumo (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Falha de conexão. Verifique sua internet');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido');
    } catch (e) {
      throw Exception('Erro ao buscar insumo: $e');
    }
  }

  Future<List<InsumoModel>> getByNome(String nome) async {
    try {
      final endpoint = '/Insumos/nome/$nome';
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => InsumoModel.fromJson(item)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}: busca falhou.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar por $nome: $e');
    }
  }
}
