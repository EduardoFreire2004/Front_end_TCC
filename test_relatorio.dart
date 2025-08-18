import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/models/InsumoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoInsumoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/models/PlantioModel.dart';

// Arquivo de teste para verificar a funcionalidade dos relatórios
// Este arquivo pode ser executado para testar a geração de PDFs

void main() async {
  // Dados de exemplo para teste
  final agrotoxicos = [
    AgrotoxicoModel(
      id: 1,
      fornecedorID: 1,
      tipoID: 1,
      nome: 'Herbicida Teste',
      unidade_Medida: 'L',
      data_Cadastro: DateTime.now(),
      qtde: 10.0,
      preco: 45.50,
    ),
    AgrotoxicoModel(
      id: 2,
      fornecedorID: 2,
      tipoID: 2,
      nome: 'Fungicida Exemplo',
      unidade_Medida: 'Kg',
      data_Cadastro: DateTime.now().subtract(Duration(days: 5)),
      qtde: 5.0,
      preco: 120.00,
    ),
  ];

  final sementes = [
    SementeModel(
      id: 1,
      fornecedorSementeID: 1,
      data_Cadastro: DateTime.now(),
      nome: 'Milho Híbrido',
      tipo: 'Grão',
      marca: 'AgroTech',
      qtde: 100.0,
      preco: 2.50,
    ),
    SementeModel(
      id: 2,
      fornecedorSementeID: 2,
      data_Cadastro: DateTime.now().subtract(Duration(days: 3)),
      nome: 'Soja Transgênica',
      tipo: 'Leguminosa',
      marca: 'SeedCorp',
      qtde: 50.0,
      preco: 8.75,
    ),
  ];

  final insumos = [
    InsumoModel(
      id: 1,
      categoriaID: 1,
      fornecedorID: 1,
      nome: 'Adubo NPK',
      unidade_Medida: 'Kg',
      data_Cadastro: DateTime.now(),
      qtde: 500.0,
      preco: 3.20,
    ),
    InsumoModel(
      id: 2,
      categoriaID: 2,
      fornecedorID: 2,
      nome: 'Calcário Agrícola',
      unidade_Medida: 'Ton',
      data_Cadastro: DateTime.now().subtract(Duration(days: 7)),
      qtde: 2.0,
      preco: 150.00,
    ),
  ];

  final aplicacoesInsumos = [
    AplicacaoInsumoModel(
      id: 1,
      insumoID: 1,
      lavouraID: 1,
      descricao: 'Aplicação de adubo NPK na lavoura de milho',
      dataHora: DateTime.now().subtract(Duration(days: 2)),
    ),
    AplicacaoInsumoModel(
      id: 2,
      insumoID: 2,
      lavouraID: 1,
      descricao: 'Aplicação de calcário para correção do solo',
      dataHora: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  final aplicacoes = [
    AplicacaoModel(
      id: 1,
      agrotoxicoID: 1,
      lavouraID: 1,
      descricao: 'Aplicação de herbicida para controle de ervas daninhas',
      dataHora: DateTime.now().subtract(Duration(days: 1)),
    ),
    AplicacaoModel(
      id: 2,
      agrotoxicoID: 2,
      lavouraID: 1,
      descricao: 'Aplicação de fungicida preventivo',
      dataHora: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  final plantios = [
    PlantioModel(
      id: 1,
      sementeID: 1,
      lavouraID: 1,
      descricao: 'Plantio de milho híbrido na área principal',
      dataHora: DateTime.now().subtract(Duration(days: 10)),
      areaPlantada: 50.0,
    ),
    PlantioModel(
      id: 2,
      sementeID: 2,
      lavouraID: 1,
      descricao: 'Plantio de soja em área de rotação',
      dataHora: DateTime.now().subtract(Duration(days: 15)),
      areaPlantada: 30.0,
    ),
  ];

  print('Iniciando testes de relatórios...');

  try {
    print('Gerando relatório de agrotóxicos...');
    await RelatorioService.gerarRelatorioAgrotoxicos(agrotoxicos);
    print('✓ Relatório de agrotóxicos gerado com sucesso!');

    print('Gerando relatório de sementes...');
    await RelatorioService.gerarRelatorioSementes(sementes);
    print('✓ Relatório de sementes gerado com sucesso!');

    print('Gerando relatório de insumos...');
    await RelatorioService.gerarRelatorioInsumos(insumos);
    print('✓ Relatório de insumos gerado com sucesso!');

    print('Gerando relatório de aplicações de insumos...');
    await RelatorioService.gerarRelatorioAplicacoesInsumos(aplicacoesInsumos);
    print('✓ Relatório de aplicações de insumos gerado com sucesso!');

    print('Gerando relatório de aplicações de agrotóxicos...');
    await RelatorioService.gerarRelatorioAplicacoes(aplicacoes);
    print('✓ Relatório de aplicações de agrotóxicos gerado com sucesso!');

    print('Gerando relatório de plantios...');
    await RelatorioService.gerarRelatorioPlantios(plantios);
    print('✓ Relatório de plantios gerado com sucesso!');

    print('\n🎉 Todos os relatórios foram gerados com sucesso!');
    print('Os PDFs foram abertos no visualizador padrão do sistema.');
  } catch (e) {
    print('❌ Erro ao gerar relatórios: $e');
  }
}

// Para executar este teste:
// 1. Certifique-se de que o projeto está configurado
// 2. Execute: dart test_relatorio.dart
// 3. Verifique se os PDFs são gerados corretamente
