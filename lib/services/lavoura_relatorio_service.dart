import 'package:flutter_fgl_1/services/aplicacao_service.dart';
import 'package:flutter_fgl_1/repositories/PlantioRepo.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';

class LavouraRelatorioService {
  static final AplicacaoService _aplicacaoService = AplicacaoService();
  static final PlantioRepo _plantioRepo = PlantioRepo();

  // Buscar aplicações de agrotóxicos por lavoura
  static Future<List<AplicacaoDto>> getAplicacoesAgrotoxicosByLavoura(
    int lavouraId,
  ) async {
    try {
      final aplicacoes = await _aplicacaoService
          .buscarAplicacoesAgrotoxicoPorLavoura(lavouraId);

      // Converter AplicacaoModel para AplicacaoDto
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

  // Buscar aplicações de insumos por lavoura
  static Future<List<AplicacaoDto>> getAplicacoesInsumosByLavoura(
    int lavouraId,
  ) async {
    try {
      final aplicacoes = await _aplicacaoService
          .buscarAplicacoesInsumoPorLavoura(lavouraId);

      // Converter AplicacaoInsumoModel para AplicacaoDto
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

  // Buscar plantios por lavoura
  static Future<List<PlantioDto>> getPlantiosByLavoura(int lavouraId) async {
    try {
      final plantios = await _plantioRepo.fetchByLavoura(lavouraId);

      // Converter PlantioModel para PlantioDto
      return plantios
          .map(
            (plantio) => PlantioDto(
              cultura: plantio.descricao,
              dataPlantio:
                  plantio.dataHora.toString().split(' ')[0], // Apenas a data
              areaPlantada: plantio.areaPlantada,
              status: 'Ativo', // Status padrão já que não existe no modelo
            ),
          )
          .toList();
    } catch (e) {
      print('Erro ao buscar plantios: $e');
      return [];
    }
  }

  // Buscar dados completos da lavoura
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
