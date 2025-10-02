import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/CustosModel.dart';
import '../services/api_service.dart';

class CustoRepo {
  Future<List<CustoModel>> getAll() async {
    try {
      final response = await ApiService.get('/Custos');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => CustoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar os custos.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } on TimeoutException {
      throw Exception('Tempo de resposta da API excedido.');
    } on FormatException {
      throw Exception('Erro ao interpretar os dados recebidos.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> create(CustoModel custo) async {
    try {
      final response = await ApiService.post(
        '/Custos',
        jsonEncode(custo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar custo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar custo: $e');
    }
  }

  Future<void> update(CustoModel custo) async {
    try {
      final response = await ApiService.put(
        '/Custos/${custo.id}',
        jsonEncode(custo.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar custo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar custo: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/Custos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar custo (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar custo: $e');
    }
  }

  Future<List<CustoModel>> fetchByLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get('/Custos/lavoura/$lavouraId');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => CustoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível buscar os custos da lavoura.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao buscar por lavoura.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao buscar custo por lavoura.');
    } on FormatException {
      throw Exception('Erro ao interpretar dados dos custos por lavoura.');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar por lavoura: $e');
    }
  }
}

