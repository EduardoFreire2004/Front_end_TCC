import 'dart:typed_data';
import 'dart:io' show File, Process; // Apenas usado fora do Web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Compatibilidade com Web (usa download direto)
import 'package:universal_html/html.dart' as html;

// Compatibilidade com Android/iOS/Desktop (usa diretório do app)
import 'package:path_provider/path_provider.dart';

class PdfService {
  /// Gera um relatório PDF compatível com Web e plataformas nativas.
  Future<void> gerarRelatorio<T>(
    String titulo,
    List<T> dados, {
    DateTime? dataInicio,
    DateTime? dataFim,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),

        // Cabeçalho
        header: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                "FGL - Freire Gerenciamento de Lavouras",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                titulo,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              if (dataInicio != null && dataFim != null) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  "Período: ${_formatDate(dataInicio)} a ${_formatDate(dataFim)}",
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              pw.Divider(color: PdfColors.green, thickness: 1),
            ],
          ),
        ),

        // Rodapé
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            "Página ${context.pageNumber} de ${context.pagesCount}",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),

        // Conteúdo
        build: (pw.Context context) {
          if (dados.isEmpty) {
            return [
              pw.Center(
                child: pw.Text(
                  "Nenhum dado disponível para o período selecionado.",
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.red600,
                  ),
                ),
              ),
            ];
          }

          // Extrai colunas
          Map<String, dynamic> primeiro = {};
          try {
            final dynamic conv = (dados.first as dynamic).toJson();
            primeiro = Map<String, dynamic>.from(conv);
          } catch (_) {
            primeiro = {"erro": "toJson() ausente ou inválido"};
          }

          final colunas = primeiro.keys.toList();

          // Gera linhas
          final linhas = dados.map((item) {
            Map<String, dynamic> map = {};
            try {
              final dynamic conv = (item as dynamic).toJson();
              map = Map<String, dynamic>.from(conv);
            } catch (_) {
              map = {"erro": "Objeto inválido"};
            }
            return colunas.map((c) => _formatValue(map[c])).toList();
          }).toList();

          final columnWidths = {
            for (int i = 0; i < colunas.length; i++) i: const pw.FlexColumnWidth()
          };

          return [
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: columnWidths,
              children: [
                // Cabeçalho da tabela
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green50),
                  children: [
                    for (final c in colunas)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          _capitalize(c),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green900,
                          ),
                        ),
                      ),
                  ],
                ),

                // Linhas alternadas (efeito zebra)
                for (int i = 0; i < linhas.length; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i.isEven ? PdfColors.white : PdfColors.grey100,
                    ),
                    children: [
                      for (final valor in linhas[i])
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            valor,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total de registros: ${dados.length}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ),
          ];
        },
      ),
    );

    // Gera bytes
    final bytes = await pdf.save();

    if (kIsWeb) {
      // --- FLUTTER WEB ---
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "relatorio_${titulo.replaceAll(' ', '_')}.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // --- ANDROID / IOS / DESKTOP ---
      final dir = await getApplicationDocumentsDirectory();
      final safeTitle = titulo.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final file = File("${dir.path}/relatorio_$safeTitle.pdf");
      await file.writeAsBytes(bytes);
      await _abrirArquivo(file);
    }
  }

  /// Abre o PDF no app nativo (somente plataformas móveis)
  Future<void> _abrirArquivo(File file) async {
    try {
      // Tenta abrir com o app padrão
      final open = await Process.run('xdg-open', [file.path]);
      print(open);
    } catch (e) {
      print('Erro ao abrir arquivo: $e');
    }
  }

  // ------------------ AUXILIARES ------------------

  String _formatValue(dynamic value) {
    if (value == null) return "-";
    if (value is DateTime) return _formatDate(value);
    if (value is num) return value.toStringAsFixed(2);
    if (value is bool) return value ? "Sim" : "Não";
    return value.toString();
  }

  String _formatDate(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class PdfServiceLista {
  /// Gera um relatório PDF compatível com Web e plataformas nativas,
  /// agora **sem precisar passar dataInicio e dataFim**.
  Future<void> gerarRelatorio<T>(
    String titulo,
    List<T> dados,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),

        // Cabeçalho
        header: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                "FGL - Freire Gerenciamento de Lavouras",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                titulo,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              pw.Divider(color: PdfColors.green, thickness: 1),
            ],
          ),
        ),

        // Rodapé
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            "Página ${context.pageNumber} de ${context.pagesCount}",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),

        // Conteúdo
        build: (pw.Context context) {
          if (dados.isEmpty) {
            return [
              pw.Center(
                child: pw.Text(
                  "Nenhum dado disponível.",
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.red600,
                  ),
                ),
              ),
            ];
          }

          // Extrai colunas dinamicamente
          Map<String, dynamic> primeiro = {};
          try {
            final dynamic conv = (dados.first as dynamic).toJson();
            primeiro = Map<String, dynamic>.from(conv);
          } catch (_) {
            primeiro = {"erro": "toJson() ausente ou inválido"};
          }

          final colunas = primeiro.keys.toList();

          // Gera linhas dinamicamente
          final linhas = dados.map((item) {
            Map<String, dynamic> map = {};
            try {
              final dynamic conv = (item as dynamic).toJson();
              map = Map<String, dynamic>.from(conv);
            } catch (_) {
              map = {"erro": "Objeto inválido"};
            }
            return colunas.map((c) => _formatValue(map[c])).toList();
          }).toList();

          final columnWidths = {
            for (int i = 0; i < colunas.length; i++) i: const pw.FlexColumnWidth()
          };

          return [
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: columnWidths,
              children: [
                // Cabeçalho da tabela
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green50),
                  children: [
                    for (final c in colunas)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          _capitalize(c),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green900,
                          ),
                        ),
                      ),
                  ],
                ),

                // Linhas alternadas (efeito zebra)
                for (int i = 0; i < linhas.length; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i.isEven ? PdfColors.white : PdfColors.grey100,
                    ),
                    children: [
                      for (final valor in linhas[i])
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            valor,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total de registros: ${dados.length}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // --- FLUTTER WEB ---
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "relatorio_${titulo.replaceAll(' ', '_')}.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // --- ANDROID / IOS / DESKTOP ---
      final dir = await getApplicationDocumentsDirectory();
      final safeTitle = titulo.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final file = File("${dir.path}/relatorio_$safeTitle.pdf");
      await file.writeAsBytes(bytes);
      await _abrirArquivo(file);
    }
  }

  Future<void> _abrirArquivo(File file) async {
    try {
      final open = await Process.run('xdg-open', [file.path]);
      print(open);
    } catch (e) {
      print('Erro ao abrir arquivo: $e');
    }
  }

  String _formatValue(dynamic value) {
    if (value == null) return "-";
    if (value is DateTime) return _formatDate(value);
    if (value is num) return value.toStringAsFixed(2);
    if (value is bool) return value ? "Sim" : "Não";
    return value.toString();
  }

  String _formatDate(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
