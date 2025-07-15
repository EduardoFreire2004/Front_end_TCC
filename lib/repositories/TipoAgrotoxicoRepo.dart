import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/TipoAgrotoxicoModel.dart';
import '../services/api_service.dart';

class TipoAgrotoxicoRepo {
  Future<List<TipoAgrotoxicoModel>> getAll() async {
    try {
      final response = await ApiService.get('/TipoAgrotoxicos');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) =>
                  TipoAgrotoxicoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar os tipos.',
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

  Future<void> create(TipoAgrotoxicoModel tipo) async {
    try {
      final response = await ApiService.post(
        '/TipoAgrotoxicos',
        jsonEncode(tipo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar tipo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar tipo: $e');
    }
  }

  Future<void> update(TipoAgrotoxicoModel tipo) async {
    try {
      final response = await ApiService.put(
        '/TipoAgrotoxicos/${tipo.id}',
        jsonEncode(tipo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar tipo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar tipo: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/TipoAgrotoxicos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar tipo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar tipo: $e');
    }
  }

  Future<TipoAgrotoxicoModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/TipoAgrotoxicos/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return TipoAgrotoxicoModel.fromJson(jsonMap);
        } else {
          throw Exception('Resposta vazia do servidor');
        }
      } else {
        throw Exception('Erro ao buscar tipo (${response.statusCode})');
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
