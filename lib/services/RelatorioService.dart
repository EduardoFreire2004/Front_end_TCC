import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoInsumoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/models/ColheitaModel.dart';
import 'package:flutter_fgl_1/models/MovimentacaoEstoqueModel.dart';
import 'package:flutter_fgl_1/models/PlantioModel.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';

import '../services/api_service.dart';

class RelatorioService {
  Future<List<RelatorioAplicacaoDTO>> getRelatorioAplicacao(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final endpoint =
        '/relatorios/aplicacao/$lavouraId'
        '?dataInicio=${dataInicio.toIso8601String()}'
        '&dataFim=${dataFim.toIso8601String()}';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioAplicacaoDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioAplicacaoInsumoDTO>> getRelatorioAplicacaoInsumo(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final endpoint =
        '/relatorios/aplicacao-insumo/$lavouraId'
        '?dataInicio=${dataInicio.toIso8601String()}'
        '&dataFim=${dataFim.toIso8601String()}';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioAplicacaoInsumoDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioPlantioDTO>> getRelatorioPlantio(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final endpoint =
        '/relatorios/plantio/$lavouraId'
        '?dataInicio=${dataInicio.toIso8601String()}'
        '&dataFim=${dataFim.toIso8601String()}';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioPlantioDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioColheitaDTO>> getRelatorioColheita(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final endpoint =
        '/relatorios/colheita/$lavouraId'
        '?dataInicio=${dataInicio.toIso8601String()}'
        '&dataFim=${dataFim.toIso8601String()}';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioColheitaDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioMovimentacaoDTO>> getRelatorioMovimentacaoEstoque(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final endpoint =
        '/relatorios/movimentacao-estoque/$lavouraId'
        '?dataInicio=${dataInicio.toIso8601String()}'
        '&dataFim=${dataFim.toIso8601String()}';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioMovimentacaoDTO.fromJson(e)).toList();
  }

  /// Função genérica que busca o JSON
  Future<List<dynamic>> _fetchRelatorio(String endpoint) async {
    try {
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Parâmetros inválidos');
      } else {
        throw Exception(
          'Erro ${response.statusCode}: Falha ao carregar relatório.',
        );
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } on TimeoutException {
      throw Exception('Tempo de resposta da API excedido.');
    } on FormatException {
      throw Exception('Erro ao interpretar os dados do relatório.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<List<RelatorioAgrotoxicoDTO>> getRelatorioAgrotoxico() async {
    final endpoint = '/relatorios/agrotoxico';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioAgrotoxicoDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioSementeDTO>> getRelatorioSemente() async {
    final endpoint = '/relatorios/semente';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioSementeDTO.fromJson(e)).toList();
  }

  Future<List<RelatorioInsumoDTO>> getRelatorioInsumo() async {
    final endpoint = '/relatorios/insumo';
    final data = await _fetchRelatorio(endpoint);
    return data.map((e) => RelatorioInsumoDTO.fromJson(e)).toList();
  }
}
