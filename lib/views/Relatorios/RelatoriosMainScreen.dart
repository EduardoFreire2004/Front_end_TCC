import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/services/pdf_service.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class RelatoriosMainScreen extends StatefulWidget {
  final int lavouraId;
  final String nomeLavoura;

  const RelatoriosMainScreen({
    Key? key,
    required this.lavouraId,
    required this.nomeLavoura,
  }) : super(key: key);

  @override
  State<RelatoriosMainScreen> createState() => _RelatoriosMainScreenState();
}

class _RelatoriosMainScreenState extends State<RelatoriosMainScreen> {
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String? _tipoRelatorioSelecionado;
  bool _isGenerating = false;
  String? _errorMessage;
  late RelatorioService _relatorioService;
  late PdfService _pdfService;

  @override
  void initState() {
    super.initState();
    _relatorioService = RelatorioService();
    _pdfService = PdfService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Relatórios em PDF',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            const Text(
              'Tipo de Relatório',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildRelatorioGrid(),
            const SizedBox(height: 24),
            if (_tipoRelatorioSelecionado != null) _buildPeriodoRelatorio(),
            const SizedBox(height: 24),
            _buildInstrucoes(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assessment,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Relatórios em PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Lavoura: ${widget.nomeLavoura}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gere relatórios detalhados em formato PDF',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatorioGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildRelatorioCard(
          context,
          icon: Icons.attach_money,
          title: 'Relatório de Custos',
          subtitle: 'Análise de custos',
          color: Colors.green,
          onTap: () => _selecionarTipoRelatorio('custos'),
        ),
        _buildRelatorioCard(
          context,
          icon: Icons.inventory_2,
          title: 'Relatório de Insumos',
          subtitle: 'Estoque e uso de insumos',
          color: Colors.blue,
          onTap: () => _selecionarTipoRelatorio('insumos'),
        ),
        _buildRelatorioCard(
          context,
          icon: Icons.swap_horiz,
          title: 'Relatório de Movimentações',
          subtitle: 'Controle de estoque',
          color: Colors.orange,
          onTap: () => _selecionarTipoRelatorio('movimentacoes'),
        ),
        _buildRelatorioCard(
          context,
          icon: Icons.warning,
          title: 'Relatório de Agrotóxicos',
          subtitle: 'Aplicações de agrotóxicos',
          color: Colors.red,
          onTap: () => _selecionarTipoRelatorio('agrotoxicos'),
        ),
        _buildRelatorioCard(
          context,
          icon: Icons.eco,
          title: 'Relatório de Plantios',
          subtitle: 'Histórico de plantios',
          color: Colors.green,
          onTap: () => _selecionarTipoRelatorio('plantios'),
        ),
        _buildRelatorioCard(
          context,
          icon: Icons.grass,
          title: 'Relatório de Colheitas',
          subtitle: 'Resultados das colheitas',
          color: Colors.amber,
          onTap: () => _selecionarTipoRelatorio('colheitas'),
        ),
      ],
    );
  }

  Widget _buildPeriodoRelatorio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Período do Relatório',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Data Início',
                _dataInicio,
                (d) => setState(() => _dataInicio = d),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                'Data Fim',
                _dataFim,
                (d) => setState(() => _dataFim = d),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed:
                _podeGerarRelatorio() && !_isGenerating
                    ? _gerarRelatorio
                    : null,
            icon:
                _isGenerating
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: Text(
              _isGenerating ? 'Gerando PDF...' : 'Gerar Relatório PDF',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInstrucoes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: const Text(
        '1. Selecione o tipo de relatório\n'
        '2. Escolha o período\n'
        '3. Clique em "Gerar Relatório PDF"\n'
        '4. O PDF será salvo nos documentos',
        style: TextStyle(color: Colors.blue, fontSize: 14, height: 1.5),
      ),
    );
  }

  Widget _buildRelatorioCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected =
        _tipoRelatorioSelecionado != null &&
        _getTipoRelatorioFromTitle(title) == _tipoRelatorioSelecionado;

    return Card(
      elevation: isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) onChanged(selectedDate);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'Selecionar data',
                  style: TextStyle(
                    color: date != null ? Colors.black87 : Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selecionarTipoRelatorio(String tipo) {
    setState(() {
      _tipoRelatorioSelecionado = tipo;
      _dataInicio = null;
      _dataFim = null;
      _errorMessage = null;
    });
  }

  String _getTipoRelatorioFromTitle(String title) {
    if (title.contains('Custos')) return 'custos';
    if (title.contains('Insumos')) return 'insumos';
    if (title.contains('Movimentações')) return 'movimentacoes';
    if (title.contains('Agrotóxicos')) return 'agrotoxicos';
    if (title.contains('Plantios')) return 'plantios';
    if (title.contains('Colheitas')) return 'colheitas';
    return '';
  }

  bool _podeGerarRelatorio() =>
      _tipoRelatorioSelecionado != null &&
      _dataInicio != null &&
      _dataFim != null;

  Future<void> _gerarRelatorio() async {
    if (!_podeGerarRelatorio()) return;

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final dataInicio = _dataInicio!;
      final dataFim = _dataFim!;
      File? file;

      switch (_tipoRelatorioSelecionado) {
        case 'plantios':
          final dados = await _relatorioService.getRelatorioPlantio(
            widget.lavouraId,
            dataInicio,
            dataFim,
          );
          await _pdfService.gerarRelatorio("Relatório de Plantios", dados);
          break;

        case 'agrotoxicos':
          final dados = await _relatorioService.getRelatorioAplicacao(
            widget.lavouraId,
            dataInicio,
            dataFim,
          );
          await _pdfService.gerarRelatorio(
            "Relatório de Aplicações de Agrotóxicos",
            dados,
          );
          break;

        case 'insumos':
          final dados = await _relatorioService.getRelatorioAplicacaoInsumo(
            widget.lavouraId,
            dataInicio,
            dataFim,
          );
          await _pdfService.gerarRelatorio("Relatório de Insumos", dados);

          break;

        case 'colheitas':
          final dados = await _relatorioService.getRelatorioColheita(
            widget.lavouraId,
            dataInicio,
            dataFim,
          );
          await _pdfService.gerarRelatorio("Relatório de Colheitas", dados);
          break;

        case 'movimentacoes':
          final dados = await _relatorioService.getRelatorioMovimentacaoEstoque(
            widget.lavouraId,
            dataInicio,
            dataFim,
          );
          await _pdfService.gerarRelatorio("Relatório de Movimentações", dados);
          break;

        case 'custos':
          setState(
            () => _errorMessage = 'Relatório de custos ainda não implementado',
          );
          return;

        default:
          setState(() => _errorMessage = 'Tipo de relatório não reconhecido');
          return;
      }

      if (file != null) {
        // Abre o PDF no app nativo de visualização
        await OpenFilex.open(file.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Relatório ${_getNomeRelatorio()} gerado com sucesso!',
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro ao gerar relatório: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  String _getNomeRelatorio() {
    switch (_tipoRelatorioSelecionado) {
      case 'plantios':
        return 'de Plantios';
      case 'agrotoxicos':
        return 'de Agrotóxicos';
      case 'insumos':
        return 'de Insumos';
      case 'colheitas':
        return 'de Colheitas';
      case 'movimentacoes':
        return 'de Movimentações';
      case 'custos':
        return 'de Custos';
      default:
        return '';
    }
  }
}
