import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/FornecedoresModel.dart';
import '../services/api_service.dart';

class FornecedoresRepo {
  Future<List<FornecedoresModel>> getAll() async {
    try {
      final response = await ApiService.get('/Fornecedores');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) =>
                  FornecedoresModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Não foi possível carregar os fornecedores.',
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

  Future<void> create(FornecedoresModel fornecedor) async {
    try {
      final response = await ApiService.post(
        '/Fornecedores',
        fornecedor.toJson(),
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

  Future<void> update(FornecedoresModel fornecedor) async {
    try {
      final response = await ApiService.put(
        '/Fornecedores/${fornecedor.id}',
        fornecedor.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erro ao atualizar fornecedor (${response.statusCode}).',
        );
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
      final response = await ApiService.delete('/Fornecedores/$id');

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

  Future<FornecedoresModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/Fornecedores/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return FornecedoresModel.fromJson(jsonMap);
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

  Future<List<FornecedoresModel>> getByParametro(
    String tipo,
    String valor,
  ) async {
    try {
      final endpoint = '/Fornecedores/buscar?tipo=$tipo&valor=$valor';
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) =>
                  FornecedoresModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}: busca falhou.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar por $tipo: $e');
    }
  }
}
