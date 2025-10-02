import 'package:flutter_fgl_1/repositories/AplicacaoInsumoRepo.dart';
import 'package:flutter_fgl_1/repositories/AplicacaoRepo.dart';
import 'package:flutter_fgl_1/repositories/PlantioRepo.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';

class LavouraRelatorioService {
  static final AplicacaoRepo _aplicacaoRepo = AplicacaoRepo();
  static final AplicacaoInsumoRepo _aplicacaoInsumoRepo = AplicacaoInsumoRepo();
  static final PlantioRepo _plantioRepo = PlantioRepo();

  static Future<List<AplicacaoDto>> getAplicacoesAgrotoxicosByLavoura(
    int lavouraId,
  ) async {
    try {
      final aplicacoes = await _aplicacaoRepo.fetchByLavoura(lavouraId);

      return aplicacoes
          .map(
            (aplicacao) => AplicacaoDto(
              id: aplicacao.id ?? 0,
              produto: aplicacao.agrotoxicoNome ?? 'N/A',
              lavoura: aplicacao.lavouraNome ?? 'N/A',
              dataAplicacao: aplicacao.dataHora.toIso8601String(),
              quantidade: aplicacao.qtde,
              unidadeMedida: aplicacao.agrotoxicoUnidadeMedida ?? 'L',
              observacoes: aplicacao.descricao ?? '',
            ),
          )
          .toList();
    } catch (e) {
      print('Erro ao buscar aplicações de agrotóxicos: $e');
      return [];
    }
  }

  static Future<List<AplicacaoDto>> getAplicacoesInsumosByLavoura(
    int lavouraId,
  ) async {
    try {
      final aplicacoes = await _aplicacaoInsumoRepo.fetchByLavoura(lavouraId);

      return aplicacoes
          .map(
            (aplicacao) => AplicacaoDto(
              id: aplicacao.id ?? 0,
              produto: aplicacao.insumoNome ?? 'N/A',
              lavoura: aplicacao.lavouraNome ?? 'N/A',
              dataAplicacao: aplicacao.dataHora.toIso8601String(),
              quantidade: aplicacao.qtde,
              unidadeMedida: aplicacao.insumoUnidadeMedida ?? 'kg',
              observacoes: aplicacao.descricao ?? '',
            ),
          )
          .toList();
    } catch (e) {
      print('Erro ao buscar aplicações de insumos: $e');
      return [];
    }
  }

  static Future<List<PlantioDto>> getPlantiosByLavoura(int lavouraId) async {
    try {
      final plantios = await _plantioRepo.fetchByLavoura(lavouraId);

      return plantios
          .map(
            (plantio) => PlantioDto(
              cultura: plantio.descricao,
              dataPlantio:
                  plantio.dataHora.toString().split(' ')[0], // Apenas a data
              areaPlantada: plantio.areaPlantada,
            ),
          )
          .toList();
    } catch (e) {
      print('Erro ao buscar plantios: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDadosCompletosLavoura(
    int lavouraId,
  ) async {
    try {
      final aplicacoesAgrotoxicos = await getAplicacoesAgrotoxicosByLavoura(
        lavouraId,
      );
      final aplicacoesInsumos = await getAplicacoesInsumosByLavoura(lavouraId);
      final plantios = await getPlantiosByLavoura(lavouraId);

      return {
        'aplicacoesAgrotoxicos': aplicacoesAgrotoxicos,
        'aplicacoesInsumos': aplicacoesInsumos,
        'plantios': plantios,
        'totalAplicacoesAgrotoxicos': aplicacoesAgrotoxicos.length,
        'totalAplicacoesInsumos': aplicacoesInsumos.length,
        'totalPlantios': plantios.length,
      };
    } catch (e) {
      print('Erro ao buscar dados completos da lavoura: $e');
      return {
        'aplicacoesAgrotoxicos': <AplicacaoDto>[],
        'aplicacoesInsumos': <AplicacaoDto>[],
        'plantios': <PlantioDto>[],
        'totalAplicacoesAgrotoxicos': 0,
        'totalAplicacoesInsumos': 0,
        'totalPlantios': 0,
      };
    }
  }
}

