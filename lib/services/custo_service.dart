import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_fgl_1/models/CustoCalculadoModel.dart';
import 'package:flutter_fgl_1/models/ResumoCustosModel.dart';
import 'package:flutter_fgl_1/models/HistoricoCustoModel.dart';
import 'package:flutter_fgl_1/config/api_config.dart';

class CustoService {
  final String token;

  CustoService({required this.token});

  /// Headers padrão para todas as requisições
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  /// 🧮 CALCULAR CUSTOS COMPLETOS DA LAVOURA
  /// POST /api/custo/calcular/{lavouraId}
  Future<CustoCalculadoModel> calcularCustosLavoura({
    required int lavouraId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      print('🔍 Calculando custos para lavoura $lavouraId');
      print(
        '📅 Período: ${dataInicio?.toIso8601String()} até ${dataFim?.toIso8601String()}',
      );

      final url = '${ApiConfig.baseUrl}/custo/calcular/$lavouraId';
      print('🌐 URL: $url');

      final body = <String, dynamic>{};
      if (dataInicio != null) body['dataInicio'] = dataInicio.toIso8601String();
      if (dataFim != null) body['dataFim'] = dataFim.toIso8601String();

      print('📤 Body: ${jsonEncode(body)}');

      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 60));

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('✅ JSON decodificado com sucesso');
        return CustoCalculadoModel.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Dados inválidos para cálculo de custos',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido ou expirado');
      } else if (response.statusCode == 404) {
        throw Exception('Lavoura não encontrada');
      } else {
        throw Exception('Erro ao calcular custos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro no serviço: $e');
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 🧮 CALCULAR CUSTOS DO ÚLTIMO MÊS
  Future<CustoCalculadoModel> calcularCustosUltimoMes(int lavouraId) async {
    try {
      final agora = DateTime.now();
      final dataInicio = DateTime(agora.year, agora.month, 1);
      final dataFim = DateTime(agora.year, agora.month + 1, 0);

      print(
        '📅 Calculando custos do último mês: ${dataInicio.toIso8601String()} até ${dataFim.toIso8601String()}',
      );

      return await calcularCustosLavoura(
        lavouraId: lavouraId,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );
    } catch (e) {
      print('❌ Erro ao calcular custos do último mês: $e');
      rethrow;
    }
  }

  /// 💰 CALCULAR CUSTO DE APLICAÇÃO ESPECÍFICA
  /// GET /api/custo/aplicacao/{aplicacaoId}
  Future<Map<String, dynamic>> calcularCustoAplicacao(int aplicacaoId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/custo/aplicacao/$aplicacaoId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Aplicação não encontrada');
      } else {
        throw Exception(
          'Erro ao calcular custo da aplicação: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 🌱 CALCULAR CUSTO DE APLICAÇÃO DE INSUMO
  /// GET /api/custo/aplicacao-insumo/{aplicacaoInsumoId}
  Future<Map<String, dynamic>> calcularCustoAplicacaoInsumo(
    int aplicacaoInsumoId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/custo/aplicacao-insumo/$aplicacaoInsumoId',
            ),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Aplicação de insumo não encontrada');
      } else {
        throw Exception(
          'Erro ao calcular custo da aplicação de insumo: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 📦 CALCULAR CUSTO DE MOVIMENTAÇÃO
  /// GET /api/custo/movimentacao/{movimentacaoId}
  Future<Map<String, dynamic>> calcularCustoMovimentacao(
    int movimentacaoId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/custo/movimentacao/$movimentacaoId',
            ),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Movimentação não encontrada');
      } else {
        throw Exception(
          'Erro ao calcular custo da movimentação: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 📈 OBTER RESUMO DE CUSTOS
  /// POST /api/custo/resumo/{lavouraId}
  Future<ResumoCustosModel> obterResumoCustos({
    required int lavouraId,
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/custo/resumo/$lavouraId'),
            headers: _headers,
            body: jsonEncode({
              'dataInicio': dataInicio.toIso8601String(),
              'dataFim': dataFim.toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return ResumoCustosModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Dados inválidos para resumo de custos',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Lavoura não encontrada');
      } else {
        throw Exception('Erro ao obter resumo: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 📊 OBTER HISTÓRICO DE CUSTOS
  /// POST /api/custo/historico/{lavouraId}
  Future<List<HistoricoCustoModel>> obterHistoricoCustos({
    required int lavouraId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (dataInicio != null) body['dataInicio'] = dataInicio.toIso8601String();
      if (dataFim != null) body['dataFim'] = dataFim.toIso8601String();

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/custo/historico/$lavouraId'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => HistoricoCustoModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Dados inválidos para histórico de custos',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Lavoura não encontrada');
      } else {
        throw Exception('Erro ao obter histórico: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro de conexão: $e');
    }
  }

  /// 🔄 ATUALIZAR CUSTOS DA LAVOURA
  /// POST /api/custo/atualizar/{lavouraId}
  Future<bool> atualizarCustosLavoura(int lavouraId) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/custo/atualizar/$lavouraId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 60));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao atualizar custos: $e');
      return false;
    }
  }

  /// 🧪 TESTAR CONEXÃO COM A API
  Future<bool> testarConexao() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/health'), headers: _headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao testar conexão: $e');
      return false;
    }
  }
}
