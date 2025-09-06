import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/PlantioModel.dart';
import '../services/api_service.dart';

class PlantioRepo {
  Future<List<PlantioModel>> getAll() async {
    try {
      final response = await ApiService.get('/Plantios');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => PlantioModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar os plantios.',
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

  Future<void> create(PlantioModel plantio) async {
    try {
      final response = await ApiService.post(
        '/Plantios',
        jsonEncode(plantio.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar plantio (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar plantio: $e');
    }
  }

  Future<void> update(PlantioModel plantio) async {
    try {
      final response = await ApiService.put(
        '/Plantios/${plantio.id}',
        jsonEncode(plantio.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar plantio (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar plantio: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Plantios/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar plantio (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar plantio: $e');
    }
  }

  Future<List<PlantioModel>> fetchByLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get('/Plantios/porlavoura/$lavouraId');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => PlantioModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível buscar plantios da lavoura.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao buscar por lavoura.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao buscar plantios por lavoura.');
    } on FormatException {
      throw Exception('Erro ao interpretar dados de plantios por lavoura.');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar por lavoura: $e');
    }
  }
}
