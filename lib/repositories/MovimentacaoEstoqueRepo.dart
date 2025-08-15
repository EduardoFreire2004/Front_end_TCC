import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../models/MovimentacaoEstoqueModel.dart';
import '../services/api_service.dart';

class MovimentacaoEstoqueRepo {
  Future<List<MovimentacaoEstoqueModel>> getAll() async {
    try {
      final response = await ApiService.get('/MovimentacaoEstoques');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MovimentacaoEstoqueModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}: falha ao listar.');
      }
    } catch (e) {
      throw Exception('Erro ao listar movimentações: $e');
    }
  }

  Future<void> create(MovimentacaoEstoqueModel model) async {
    try {
      final response = await ApiService.post(
        '/MovimentacaoEstoques',
        jsonEncode(model.toJson()),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Erro ${response.statusCode}: falha ao criar.');
      }
    } catch (e) {
      throw Exception('Erro ao criar movimentação: $e');
    }
  }

  Future<void> update(MovimentacaoEstoqueModel model) async {
    try {
      final response = await ApiService.put(
        '/MovimentacaoEstoques/${model.id}',
        jsonEncode(model.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ${response.statusCode}: falha ao atualizar.');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar movimentação: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await ApiService.delete('/MovimentacaoEstoques/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ${response.statusCode}: falha ao deletar.');
      }
    } catch (e) {
      throw Exception('Erro ao excluir movimentação: $e');
    }
  }

  Future<List<MovimentacaoEstoqueModel>> getByLavoura(int lavouraId) async {
    try {
      final response = await ApiService.get(
        '/MovimentacaoEstoques/lavoura/$lavouraId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MovimentacaoEstoqueModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}: busca falhou.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar por lavoura: $e');
    }
  }

  Future<MovimentacaoEstoqueModel?> getID(int id) async {
    try {
      final response = await ApiService.get('/MovimentacaoEstoques/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MovimentacaoEstoqueModel.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erro ${response.statusCode}: busca falhou.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar movimentação: $e');
    }
  }
}
