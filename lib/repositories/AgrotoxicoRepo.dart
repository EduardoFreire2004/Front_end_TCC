import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/AgrotoxicoModel.dart';
import '../services/api_service.dart';

class AgrotoxicoRepo {
  Future<List<AgrotoxicoModel>> getAll() async {
    try {
      final response = await ApiService.get('/Agrotoxicos');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => AgrotoxicoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}: Não foi possível carregar os agrotóxicos.');
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

  Future<void> create(AgrotoxicoModel agrotoxico) async {
    try {
      final response = await ApiService.post(
        '/Agrotoxicos',
        jsonEncode(agrotoxico.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar agrotóxico (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar agrotóxico: $e');
    }
  }

  Future<void> update(AgrotoxicoModel agrotoxico) async {
    try {
      final response = await ApiService.put(
        '/Agrotoxicos/${agrotoxico.id}',
        jsonEncode(agrotoxico.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar agrotóxico (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar agrotóxico: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Agrotoxicos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar agrotóxico (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar agrotóxico: $e');
    }
  }

  Future<AgrotoxicoModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/Agrotoxicos/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return AgrotoxicoModel.fromJson(jsonMap);
        } else {
          throw Exception('Resposta vazia do servidor');
        }
      } else {
        throw Exception('Erro ao buscar agrotóxico (${response.statusCode})');
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
