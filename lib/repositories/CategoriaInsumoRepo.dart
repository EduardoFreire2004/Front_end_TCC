import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/CategoriaInsumoModel.dart';
import '../services/api_service.dart';

class CategoriaInsumoRepo {
  Future<List<CategoriaInsumoModel>> getAll() async {
    try {
      final response = await ApiService.get('/CategoriaInsumos');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => CategoriaInsumoModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}: Não foi possível carregar as categorias.');
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

  Future<void> create(CategoriaInsumoModel categoria) async {
    try {
      final response = await ApiService.post(
        '/CategoriaInsumos',
        jsonEncode(categoria.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar categoria (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao tentar criar.');
    } on TimeoutException {
      throw Exception('Tempo de resposta excedido ao tentar criar.');
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  Future<void> update(CategoriaInsumoModel categoria) async {
    try {
      final response = await ApiService.put(
        '/CategoriaInsumos/${categoria.id}',
        jsonEncode(categoria.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar categoria (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ao atualizar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao atualizar.');
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/CategoriaInsumos/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar categoria (${response.statusCode}).');
      }
    } on SocketException {
      throw Exception('Sem internet ao tentar deletar.');
    } on TimeoutException {
      throw Exception('Tempo excedido ao tentar deletar.');
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  Future<CategoriaInsumoModel> getID(int id) async {
    try {
      final response = await ApiService.getID('/CategoriaInsumos/$id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonMap = json.decode(response.body) as Map<String, dynamic>;
          return CategoriaInsumoModel.fromJson(jsonMap);
        } else {
          throw Exception('Resposta vazia do servidor');
        }
      } else {
        throw Exception('Erro ao buscar categoria (${response.statusCode})');
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
