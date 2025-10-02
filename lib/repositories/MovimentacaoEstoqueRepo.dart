import 'dart:convert';
import 'dart:async';
import '../models/MovimentacaoEstoqueModel.dart';
import '../services/api_service.dart';

class MovimentacaoEstoqueRepo {

  Future<List<MovimentacaoEstoqueModel>> getAll() async {
    try {
      print('DEBUG: Fazendo GET para /MovimentacaoEstoques');
      final response = await ApiService.get('/MovimentacaoEstoques');
      print('DEBUG: Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MovimentacaoEstoqueModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Erro ${response.statusCode}: falha ao listar movimentações.',
        );
      }
    } catch (e) {
      print('DEBUG: Erro no getAll: $e');
      throw Exception('Erro ao listar movimentações: $e');
    }
  }

  Future<MovimentacaoEstoqueModel> create(
    MovimentacaoEstoqueModel model,
  ) async {
    try {

      if (!model.isValid()) {
        throw Exception(
          'Dados inválidos: verifique se apenas um tipo de item foi selecionado e se a quantidade é positiva.',
        );
      }

      print('DEBUG: Fazendo POST para /MovimentacaoEstoques');
      print('DEBUG: Dados enviados: ${model.toJson()}');

      final response = await ApiService.post(
        '/MovimentacaoEstoques',
        model.toJson(),
      );

      print('DEBUG: Status code: ${response.statusCode}');

      if (response.statusCode == 201) {

        final data = jsonDecode(response.body);
        return MovimentacaoEstoqueModel.fromJson(data);
      } else if (response.statusCode == 400) {

        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Dados inválidos');
      } else {
        throw Exception(
          'Erro ${response.statusCode}: falha ao criar movimentação.',
        );
      }
    } catch (e) {
      print('DEBUG: Erro no create: $e');
      throw Exception('Erro ao criar movimentação: $e');
    }
  }

  Future<void> update(MovimentacaoEstoqueModel model) async {
    try {
      if (model.id == null) {
        throw Exception('ID da movimentação é obrigatório para atualização.');
      }

      if (!model.isValid()) {
        throw Exception(
          'Dados inválidos: verifique se apenas um tipo de item foi selecionado e se a quantidade é positiva.',
        );
      }

      print('DEBUG: Fazendo PUT para /MovimentacaoEstoques/${model.id}');

      final response = await ApiService.put(
        '/MovimentacaoEstoques/${model.id}',
        model.toJson(),
      );

      print('DEBUG: Status code: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        if (response.statusCode == 400) {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Dados inválidos');
        } else {
          throw Exception(
            'Erro ${response.statusCode}: falha ao atualizar movimentação.',
          );
        }
      }
    } catch (e) {
      print('DEBUG: Erro no update: $e');
      throw Exception('Erro ao atualizar movimentação: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      print('DEBUG: Fazendo DELETE para /MovimentacaoEstoques/$id');

      final response = await ApiService.delete('/MovimentacaoEstoques/$id');

      print('DEBUG: Status code: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erro ${response.statusCode}: falha ao excluir movimentação.',
        );
      }
    } catch (e) {
      print('DEBUG: Erro no delete: $e');
      throw Exception('Erro ao excluir movimentação: $e');
    }
  }

  Future<MovimentacaoEstoqueModel?> getById(int id) async {
    try {
      print('DEBUG: Fazendo GET para /MovimentacaoEstoques/$id');

      final response = await ApiService.get('/MovimentacaoEstoques/$id');

      print('DEBUG: Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MovimentacaoEstoqueModel.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erro ${response.statusCode}: busca falhou.');
      }
    } catch (e) {
      print('DEBUG: Erro no getById: $e');
      throw Exception('Erro ao buscar movimentação: $e');
    }
  }

  Future<List<MovimentacaoEstoqueModel>> getByLavoura(int lavouraId) async {
    try {
      print('DEBUG: Filtrando movimentações por lavoura $lavouraId');

      final allMovimentacoes = await getAll();
      final filtered =
          allMovimentacoes.where((mov) => mov.lavouraID == lavouraId).toList();

      print(
        'DEBUG: Encontradas ${filtered.length} movimentações para a lavoura $lavouraId',
      );

      return filtered;
    } catch (e) {
      print('DEBUG: Erro no getByLavoura: $e');
      throw Exception('Erro ao buscar movimentações por lavoura: $e');
    }
  }

  Future<List<MovimentacaoEstoqueModel>> getByPeriod(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    try {
      print(
        'DEBUG: Filtrando movimentações por período para lavoura $lavouraId',
      );

      final movimentacoesLavoura = await getByLavoura(lavouraId);
      final filtered =
          movimentacoesLavoura
              .where(
                (mov) =>
                    mov.dataHora.isAfter(
                      dataInicio.subtract(const Duration(days: 1)),
                    ) &&
                    mov.dataHora.isBefore(dataFim.add(const Duration(days: 1))),
              )
              .toList();

      print('DEBUG: Encontradas ${filtered.length} movimentações no período');

      return filtered;
    } catch (e) {
      print('DEBUG: Erro no getByPeriod: $e');
      throw Exception('Erro ao buscar movimentações por período: $e');
    }
  }

  Future<List<MovimentacaoEstoqueModel>> getByItemType(
    int lavouraId,
    String itemType,
    int itemId,
  ) async {
    try {
      print(
        'DEBUG: Filtrando movimentações por tipo $itemType, ID $itemId para lavoura $lavouraId',
      );

      final movimentacoesLavoura = await getByLavoura(lavouraId);

      List<MovimentacaoEstoqueModel> filtered;

      switch (itemType.toLowerCase()) {
        case 'agrotoxico':
          filtered =
              movimentacoesLavoura
                  .where((mov) => mov.agrotoxicoID == itemId)
                  .toList();
          break;
        case 'semente':
          filtered =
              movimentacoesLavoura
                  .where((mov) => mov.sementeID == itemId)
                  .toList();
          break;
        case 'insumo':
          filtered =
              movimentacoesLavoura
                  .where((mov) => mov.insumoID == itemId)
                  .toList();
          break;
        default:
          throw Exception('Tipo de item inválido: $itemType');
      }

      print(
        'DEBUG: Encontradas ${filtered.length} movimentações para o tipo $itemType',
      );

      return filtered;
    } catch (e) {
      print('DEBUG: Erro no getByItemType: $e');
      throw Exception('Erro ao buscar movimentações por tipo de item: $e');
    }
  }
}

