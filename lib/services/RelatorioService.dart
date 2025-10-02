import 'dart:convert';
import 'package:flutter_fgl_1/services/pdf_service.dart';

import '../models/RelatorioDto.dart';
import '../models/RelatorioNovoModel.dart';
import 'api_service.dart';

class RelatorioService {
  RelatorioService();

  Future<RelatorioGeralDto> gerarRelatorioGeral({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {

      throw Exception(
        'Endpoint de relatório geral não implementado no backend. Use os relatórios específicos disponíveis.',
      );
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório geral: $e');
    }
  }

  Future<void> gerarRelatorioPlantios({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/plantio/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relatorioResponse = RelatorioPlantioResponseDto.fromJson(data);

        if (!relatorioResponse.success) {
          throw Exception(
            'API retornou erro: ${relatorioResponse.error ?? "Erro desconhecido"}',
          );
        }

        await PdfService.gerarRelatorioPlantios(relatorioResponse.data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de plantios: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de plantios: $e');
    }
  }

  Future<void> gerarRelatorioAgrotoxicos({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relatorioResponse = RelatorioAplicacaoResponseDto.fromJson(data);

        if (!relatorioResponse.success) {
          throw Exception(
            'API retornou erro: ${relatorioResponse.error ?? "Erro desconhecido"}',
          );
        }

        await PdfService.gerarRelatorioAplicacaoAgrotoxicos(
          relatorioResponse.data,
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de agrotóxicos: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de agrotóxicos: $e');
    }
  }

  Future<void> gerarRelatorioInsumosEstoque({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao-insumo/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relatorioResponse = RelatorioAplicacaoInsumoResponseDto.fromJson(
          data,
        );

        if (!relatorioResponse.success) {
          throw Exception(
            'API retornou erro: ${relatorioResponse.error ?? "Erro desconhecido"}',
          );
        }

        await PdfService.gerarRelatorioAplicacaoInsumos(relatorioResponse.data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de insumos: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de insumos: $e');
    }
  }

  Future<void> gerarRelatorioColheitas({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/colheita/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {

        if (response.body.isEmpty) {
          throw Exception(
            'Resposta vazia do servidor. Nenhum dado de colheita encontrado.',
          );
        }

        final data = json.decode(response.body);

        if (data == null) {
          throw Exception('Dados nulos recebidos do servidor.');
        }

        final responseDto = RelatorioColheitaResponseDto.fromJson(data);

        if (!responseDto.success) {
          throw Exception(
            'API retornou erro: ${responseDto.error ?? 'Erro desconhecido'}',
          );
        }

        await PdfService.gerarRelatorioColheitas(responseDto.data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de colheitas: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de colheitas: $e');
    }
  }

  Future<void> gerarRelatorioEstoque({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/movimentacao-estoque/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relatorioResponse =
            RelatorioMovimentacaoEstoqueResponseDto.fromJson(data);

        if (!relatorioResponse.success) {
          throw Exception(
            'API retornou erro: ${relatorioResponse.error ?? "Erro desconhecido"}',
          );
        }

        await PdfService.gerarRelatorioMovimentacaoEstoque(
          relatorioResponse.data,
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de estoque: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de estoque: $e');
    }
  }

  Future<void> gerarRelatorioAgrotoxicosEstoque({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/agrotoxico/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relatorioResponse = RelatorioAgrotoxicoResponseDto.fromJson(data);

        if (!relatorioResponse.success) {
          throw Exception(
            'API retornou erro: ${relatorioResponse.error ?? "Erro desconhecido"}',
          );
        }

        await PdfService.gerarRelatorioAgrotoxicosEstoque(
          relatorioResponse.data,
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de agrotóxicos em estoque: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de agrotóxicos em estoque: $e');
    }
  }

  Future<RelatorioAplicacaoResponseDto> verificarDadosAgrotoxicos({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioAplicacaoResponseDto.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao verificar dados de agrotóxicos: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao verificar dados de agrotóxicos: $e');
    }
  }

  Future<RelatorioAplicacaoInsumoResponseDto> verificarDadosInsumos({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao-insumo/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioAplicacaoInsumoResponseDto.fromJson(data);
      } else {
        throw Exception(
          'Erro ao verificar dados de insumos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao verificar dados de insumos: $e');
    }
  }

  Future<RelatorioColheitaResponseDto> verificarDadosColheitas({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/colheita/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioColheitaResponseDto.fromJson(data);
      } else {
        throw Exception(
          'Erro ao verificar dados de colheitas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao verificar dados de colheitas: $e');
    }
  }

  Future<RelatorioPlantioResponseDto> verificarDadosPlantios({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/plantio/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioPlantioResponseDto.fromJson(data);
      } else {
        throw Exception(
          'Erro ao verificar dados de plantios: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao verificar dados de plantios: $e');
    }
  }

  Future<RelatorioMovimentacaoEstoqueResponseDto> verificarDadosEstoque({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/movimentacao-estoque/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioMovimentacaoEstoqueResponseDto.fromJson(data);
      } else {
        throw Exception(
          'Erro ao verificar dados de estoque: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao verificar dados de estoque: $e');
    }
  }

  Future<RelatorioAgrotoxicoResponseDto> verificarDadosAgrotoxicosEstoque({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/agrotoxico/$lavouraId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Verificando dados em: $endpoint');
      final response = await ApiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioAgrotoxicoResponseDto.fromJson(data);
      } else {
        throw Exception(
          'Erro ao verificar dados de agrotóxicos estoque: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao verificar dados de agrotóxicos estoque: $e');
    }
  }
}

