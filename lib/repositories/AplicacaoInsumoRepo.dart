import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../services/api_service.dart';
import '../models/AplicacaoInsumoModel.dart';

class AplicacaoInsumoRepo {
  Future<List<AplicacaoInsumoModel>> getAll() async {
    try {
      final response = await ApiService.get('/AplicacaoInsumos');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) =>
                  AplicacaoInsumoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar as aplicações.',
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

  Future<void> create(AplicacaoInsumoModel aplicacao) async {
    try {
      final response = await ApiService.post(
        '/AplicacaoInsumos',
        aplicacao.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar aplicação (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar aplicação: $e');
    }
  }

  Future<void> update(AplicacaoInsumoModel aplicacao) async {
    try {
      final response = await ApiService.put(
        '/AplicacaoInsumos/${aplicacao.id}',
        aplicacao.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erro ao atualizar aplicação (${response.statusCode}).',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar aplicação: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/AplicacaoInsumos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar aplicação (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar aplicação: $e');
    }
  }

  Future<List<AplicacaoInsumoModel>> fetchByLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get(
        '/AplicacaoInsumos/porlavoura/$lavouraId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) =>
                  AplicacaoInsumoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível buscar aplicações da lavoura.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao buscar por lavoura.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao buscar aplicações por lavoura.');
    } on FormatException {
      throw Exception('Erro ao interpretar dados de aplicações por lavoura.');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar por lavoura: $e');
    }
  }
}
