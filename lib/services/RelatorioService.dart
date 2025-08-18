import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/AgrotoxicoModel.dart';
import '../models/SementeModel.dart';
import '../models/InsumoModel.dart';
import '../models/AplicacaoInsumoModel.dart';
import '../models/AplicacaoModel.dart';
import '../models/PlantioModel.dart';

class RelatorioService {
  static const PdfColor corPrimaria = PdfColor.fromInt(0xFF2E7D32);
  static const PdfColor corSecundaria = PdfColor.fromInt(0xFF4CAF50);
  static const PdfColor corTexto = PdfColor.fromInt(0xFF212121);
  static const PdfColor corFundo = PdfColor.fromInt(0xFFF5F5F5);

  static Future<void> gerarRelatorioAgrotoxicos(
    List<AgrotoxicoModel> agrotoxicos,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Agrotóxicos'),
              _buildTabelaAgrotoxicos(agrotoxicos),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Gerar relatório de sementes
  static Future<void> gerarRelatorioSementes(
    List<SementeModel> sementes,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Sementes'),
              _buildTabelaSementes(sementes),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Gerar relatório de insumos
  static Future<void> gerarRelatorioInsumos(List<InsumoModel> insumos) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Insumos'),
              _buildTabelaInsumos(insumos),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Gerar relatório de aplicações de insumos
  static Future<void> gerarRelatorioAplicacoesInsumos(
    List<AplicacaoInsumoModel> aplicacoes,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Aplicações de Insumos'),
              _buildTabelaAplicacoesInsumos(aplicacoes),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Gerar relatório de aplicações de agrotóxicos
  static Future<void> gerarRelatorioAplicacoes(
    List<AplicacaoModel> aplicacoes,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Aplicações de Agrotóxicos'),
              _buildTabelaAplicacoes(aplicacoes),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Gerar relatório de plantios
  static Future<void> gerarRelatorioPlantios(
    List<PlantioModel> plantios,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              _buildCabecalho('Relatório de Plantios'),
              _buildTabelaPlantios(plantios),
              _buildRodape(),
            ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Cabeçalho do relatório - Estilo simplificado
  static pw.Widget _buildCabecalho(String titulo) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: corPrimaria,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'FGL Freire Gerenciamento de Lavouras',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            titulo,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Data: ${DateTime.now().toString().split(' ')[0]}',
            style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Tabela de agrotóxicos
  static pw.Widget _buildTabelaAgrotoxicos(List<AgrotoxicoModel> agrotoxicos) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(2.0),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(1.0),
          4: pw.FlexColumnWidth(1.0),
          5: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Nome'),
              _buildCelulaCabecalho('Tipo'),
              _buildCelulaCabecalho('Qtd.'),
              _buildCelulaCabecalho('Preço'),
              _buildCelulaCabecalho('Data Cadastro'),
            ],
          ),
          // Dados
          ...agrotoxicos.map(
            (agrotoxico) => pw.TableRow(
              children: [
                _buildCelula(agrotoxico.id.toString()),
                _buildCelula(agrotoxico.nome),
                _buildCelula('Tipo ${agrotoxico.tipoID}'),
                _buildCelula('${agrotoxico.qtde} ${agrotoxico.unidade_Medida}'),
                _buildCelula('R\$ ${agrotoxico.preco.toStringAsFixed(2)}'),
                _buildCelula(agrotoxico.data_Cadastro.toString().split(' ')[0]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabela de sementes
  static pw.Widget _buildTabelaSementes(List<SementeModel> sementes) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(2.0),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(1.5),
          4: pw.FlexColumnWidth(1.0),
          5: pw.FlexColumnWidth(1.0),
          6: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Nome'),
              _buildCelulaCabecalho('Tipo'),
              _buildCelulaCabecalho('Marca'),
              _buildCelulaCabecalho('Qtd.'),
              _buildCelulaCabecalho('Preço'),
              _buildCelulaCabecalho('Data Cadastro'),
            ],
          ),
          // Dados
          ...sementes.map(
            (semente) => pw.TableRow(
              children: [
                _buildCelula(semente.id.toString()),
                _buildCelula(semente.nome),
                _buildCelula(semente.tipo),
                _buildCelula(semente.marca),
                _buildCelula(semente.qtde.toString()),
                _buildCelula('R\$ ${semente.preco.toStringAsFixed(2)}'),
                _buildCelula(semente.data_Cadastro.toString().split(' ')[0]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabela de insumos
  static pw.Widget _buildTabelaInsumos(List<InsumoModel> insumos) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(2.0),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(1.0),
          4: pw.FlexColumnWidth(1.0),
          5: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Nome'),
              _buildCelulaCabecalho('Categoria'),
              _buildCelulaCabecalho('Qtd.'),
              _buildCelulaCabecalho('Preço'),
              _buildCelulaCabecalho('Data Cadastro'),
            ],
          ),
          // Dados
          ...insumos.map(
            (insumo) => pw.TableRow(
              children: [
                _buildCelula(insumo.id.toString()),
                _buildCelula(insumo.nome),
                _buildCelula('Cat. ${insumo.categoriaID}'),
                _buildCelula('${insumo.qtde} ${insumo.unidade_Medida}'),
                _buildCelula('R\$ ${insumo.preco.toStringAsFixed(2)}'),
                _buildCelula(insumo.data_Cadastro.toString().split(' ')[0]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabela de aplicações de insumos
  static pw.Widget _buildTabelaAplicacoesInsumos(
    List<AplicacaoInsumoModel> aplicacoes,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(1.5),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(2.5),
          4: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Insumo ID'),
              _buildCelulaCabecalho('Lavoura ID'),
              _buildCelulaCabecalho('Descrição'),
              _buildCelulaCabecalho('Data/Hora'),
            ],
          ),
          // Dados
          ...aplicacoes.map(
            (aplicacao) => pw.TableRow(
              children: [
                _buildCelula(aplicacao.id.toString()),
                _buildCelula(aplicacao.insumoID.toString()),
                _buildCelula(aplicacao.lavouraID.toString()),
                _buildCelula(aplicacao.descricao),
                _buildCelula(aplicacao.dataHora.toString().split(' ')[0]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabela de aplicações de agrotóxicos
  static pw.Widget _buildTabelaAplicacoes(List<AplicacaoModel> aplicacoes) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(1.5),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(2.5),
          4: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Agrotóxico ID'),
              _buildCelulaCabecalho('Lavoura ID'),
              _buildCelulaCabecalho('Descrição'),
              _buildCelulaCabecalho('Data/Hora'),
            ],
          ),
          // Dados
          ...aplicacoes.map(
            (aplicacao) => pw.TableRow(
              children: [
                _buildCelula(aplicacao.id.toString()),
                _buildCelula(aplicacao.agrotoxicoID.toString()),
                _buildCelula(aplicacao.lavouraID.toString()),
                _buildCelula(aplicacao.descricao),
                _buildCelula(aplicacao.dataHora.toString().split(' ')[0]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabela de plantios
  static pw.Widget _buildTabelaPlantios(List<PlantioModel> plantios) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      child: pw.Table(
        border: pw.TableBorder.all(color: corSecundaria, width: 1),
        columnWidths: const {
          0: pw.FlexColumnWidth(0.5),
          1: pw.FlexColumnWidth(1.5),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(2.0),
          4: pw.FlexColumnWidth(1.0),
          5: pw.FlexColumnWidth(1.0),
        },
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            decoration: pw.BoxDecoration(color: corSecundaria),
            children: [
              _buildCelulaCabecalho('ID'),
              _buildCelulaCabecalho('Semente ID'),
              _buildCelulaCabecalho('Lavoura ID'),
              _buildCelulaCabecalho('Descrição'),
              _buildCelulaCabecalho('Data/Hora'),
              _buildCelulaCabecalho('Área (ha)'),
            ],
          ),
          // Dados
          ...plantios.map(
            (plantio) => pw.TableRow(
              children: [
                _buildCelula(plantio.id.toString()),
                _buildCelula(plantio.sementeID.toString()),
                _buildCelula(plantio.lavouraID.toString()),
                _buildCelula(plantio.descricao),
                _buildCelula(plantio.dataHora.toString().split(' ')[0]),
                _buildCelula(plantio.areaPlantada.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Célula de cabeçalho
  static pw.Widget _buildCelulaCabecalho(String texto) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        texto,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // Célula de dados
  static pw.Widget _buildCelula(String texto) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        texto,
        style: pw.TextStyle(color: corTexto, fontSize: 11),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // Rodapé do relatório - Estilo simplificado
  static pw.Widget _buildRodape() {
    return pw.Container(
      margin: const pw.EdgeInsets.all(20),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: corFundo,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: corSecundaria, width: 1),
      ),
      child: pw.Text(
        'FGL Freire Gerenciamento de Lavouras - Sistema de Gestão Agrícola',
        style: pw.TextStyle(
          color: corTexto,
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
