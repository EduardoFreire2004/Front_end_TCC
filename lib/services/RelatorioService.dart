import 'dart:convert';
import '../models/RelatorioDto.dart';
import 'api_service.dart';

class RelatorioService {
  RelatorioService();

  // Método para testar conectividade com a API
  Future<bool> testarConectividade() async {
    try {
      print('Testando conectividade com a API...');
      // Testar com um endpoint que sabemos que existe
      final response = await ApiService.get('/relatorios/plantio/1');
      print('Status code do teste: ${response.statusCode}');
      // Aceitar tanto 200 quanto 401 (401 significa que o endpoint existe mas precisa de auth)
      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      print('Erro no teste de conectividade: $e');
      return false;
    }
  }

  Future<RelatorioGeralDto> gerarRelatorioGeral({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      // Como não existe endpoint "geral", vamos combinar dados de plantios e aplicações
      // ou você pode implementar um endpoint geral no backend
      throw Exception(
        'Endpoint de relatório geral não implementado no backend. Use os relatórios específicos disponíveis.',
      );
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório geral: $e');
    }
  }

  Future<RelatorioPlantiosDto> gerarRelatorioPlantios({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/plantio/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioPlantiosDto.fromJson(data);
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

  Future<RelatorioAplicacoesResponseDto> gerarRelatorioAgrotoxicos({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioAplicacoesResponseDto.fromJson(data);
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

  Future<RelatorioAplicacoesDto> gerarRelatorioInsumosEstoque({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/aplicacao-insumo/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioAplicacoesDto.fromJson(data);
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

  Future<RelatorioColheitasDto> gerarRelatorioColheitas({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/colheita/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioColheitasDto.fromJson(data);
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

  Future<RelatorioCustosDto> gerarRelatorioCustos({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      // Endpoint de custos não implementado no backend
      throw Exception(
        'Endpoint de relatório de custos não implementado no backend.',
      );
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de custos: $e');
    }
  }

  Future<RelatorioEstoqueDto> gerarRelatorioEstoque({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/movimentacao-estoque/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioEstoqueDto.fromJson(data);
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

  Future<RelatorioEstoqueDto> gerarRelatorioSementes({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/semente/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioEstoqueDto.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint não encontrado (404). Verifique se o backend está configurado corretamente.',
        );
      } else {
        throw Exception(
          'Erro ao gerar relatório de sementes: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao gerar relatório de sementes: $e');
    }
  }

  Future<RelatorioEstoqueDto> gerarRelatorioAgrotoxicosEstoque({
    required int usuarioId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final endpoint =
          '/relatorios/agrotoxico/$usuarioId?dataInicio=${dataInicio.toIso8601String().split('T')[0]}&dataFim=${dataFim.toIso8601String().split('T')[0]}';

      print('Tentando acessar endpoint: $endpoint');
      final response = await ApiService.get(endpoint);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatorioEstoqueDto.fromJson(data);
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
}
