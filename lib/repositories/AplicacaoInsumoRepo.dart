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

  Future<AplicacaoInsumoModel?> getById(int id) async {
    try {
      final response = await ApiService.get('/AplicacaoInsumos/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AplicacaoInsumoModel.fromJson(data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null; // Aplicação não encontrada
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível buscar a aplicação.',
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

  Future<AplicacaoInsumoModel> create(AplicacaoInsumoModel aplicacao) async {
    try {
      final response = await ApiService.post(
        '/AplicacaoInsumos',
        aplicacao.toJson(),
      );

      if (response.statusCode == 201) {

        final data = jsonDecode(response.body);
        return AplicacaoInsumoModel.fromJson(data as Map<String, dynamic>);
      } else if (response.statusCode == 400) {

        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao criar aplicação');
      } else {
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
        if (response.statusCode == 400) {

          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['message'] ?? 'Erro ao atualizar aplicação',
          );
        } else {
          throw Exception(
            'Erro ao atualizar aplicação (${response.statusCode}).',
          );
        }
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
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

  Future<bool> verificarEstoqueDisponivel(
    int insumoId,
    double quantidade,
  ) async {
    try {

      return true;
    } catch (e) {
      throw Exception('Erro ao verificar estoque: $e');
    }
  }

  Future<List<AplicacaoInsumoModel>> buscarComFiltros({
    int? lavouraId,
    int? insumoId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {

      final queryParams = <String>[];

      if (lavouraId != null) {
        queryParams.add('lavouraId=$lavouraId');
      }
      if (insumoId != null) {
        queryParams.add('insumoId=$insumoId');
      }
      if (dataInicio != null) {
        queryParams.add('dataInicio=${dataInicio.toIso8601String()}');
      }
      if (dataFim != null) {
        queryParams.add('dataFim=${dataFim.toIso8601String()}');
      }

      final queryString =
          queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
      final response = await ApiService.get('/AplicacaoInsumos$queryString');

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
          'Erro ${response.statusCode}: Não foi possível buscar aplicações com filtros.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao buscar com filtros.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao buscar com filtros.');
    } on FormatException {
      throw Exception('Erro ao interpretar dados de aplicações com filtros.');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar com filtros: $e');
    }
  }
}

