import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_fgl_1/models/RendimentoColheitaModel.dart';

import '../models/ColheitaModel.dart';
import '../services/api_service.dart';

class ColheitaRepo {
  Future<List<ColheitaModel>> getAll() async {
    try {
      final response = await ApiService.get('/Colheitas');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => ColheitaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar as colheitas.',
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

  Future<void> create(ColheitaModel colheita) async {
    try {
      final response = await ApiService.post('/Colheitas', colheita.toJson());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar colheita (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar colheita: $e');
    }
  }

  Future<void> update(ColheitaModel colheita) async {
    try {
      final response = await ApiService.put(
        '/Colheitas/${colheita.id}',
        colheita.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar colheita (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar colheita: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Colheitas/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar colheita (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar colheita: $e');
    }
  }

  Future<List<ColheitaModel>> fetchByLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get('/Colheitas/porlavoura/$lavouraId');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => ColheitaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível buscar colheita da lavoura.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao buscar por lavoura.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao buscar colheita por lavoura.');
    } on FormatException {
      throw Exception('Erro ao interpretar dados da colheita por lavoura.');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar por lavoura: $e');
    }
  }

  Future<RendimentoColheitaModel> getRendimentoPorLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get(
        '/Colheitas/rendimento/lavoura/$lavouraId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RendimentoColheitaModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Nenhuma colheita encontrada para a lavoura.');
      } else {
        throw Exception(
          'Erro ${response.statusCode}: não foi possível obter o rendimento.',
        );
      }
    } catch (e) {
      throw Exception('Erro ao buscar rendimento: $e');
    }
  }
}
