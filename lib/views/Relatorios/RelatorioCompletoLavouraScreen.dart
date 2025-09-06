import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/services/lavoura_relatorio_service.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:flutter_fgl_1/services/pdf_service.dart';

class RelatorioCompletoLavouraScreen extends StatefulWidget {
  final int lavouraId;
  final String nomeLavoura;

  const RelatorioCompletoLavouraScreen({
    Key? key,
    required this.lavouraId,
    required this.nomeLavoura,
  }) : super(key: key);

  @override
  State<RelatorioCompletoLavouraScreen> createState() =>
      _RelatorioCompletoLavouraScreenState();
}

class _RelatorioCompletoLavouraScreenState
    extends State<RelatorioCompletoLavouraScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _dadosLavoura;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dados = await LavouraRelatorioService.getDadosCompletosLavoura(
        widget.lavouraId,
      );
      setState(() {
        _dadosLavoura = dados;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _gerarPDF() async {
    if (_dadosLavoura == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Carregue os dados primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await PdfService.generateRelatorioCompletoPDF(
      nomeLavoura: widget.nomeLavoura,
      plantios: _dadosLavoura!['plantios'] as List<PlantioDto>,
      aplicacoesAgrotoxicos:
          _dadosLavoura!['aplicacoesAgrotoxicos'] as List<AplicacaoDto>,
      aplicacoesInsumos:
          _dadosLavoura!['aplicacoesInsumos'] as List<AplicacaoDto>,
      context: context,
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAplicacaoCard(AplicacaoDto aplicacao, String tipo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                tipo == 'Agrotóxico'
                    ? Colors.red.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            tipo == 'Agrotóxico' ? Icons.pest_control : Icons.science,
            color: tipo == 'Agrotóxico' ? Colors.red : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          aplicacao.produto,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Tipo: $tipo'),
            Text('Data: ${aplicacao.dataAplicacao.split('T')[0]}'),
            if (aplicacao.observacoes.isNotEmpty)
              Text('Observações: ${aplicacao.observacoes}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${aplicacao.quantidade.toStringAsFixed(2)} ${aplicacao.unidadeMedida}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantioCard(PlantioDto plantio) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.eco, color: Colors.green, size: 20),
        ),
        title: Text(
          plantio.cultura,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Data: ${plantio.dataPlantio}'),
            Text('Status: ${plantio.status}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${plantio.areaPlantada.toStringAsFixed(2)} ha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${children.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (children.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600], size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Nenhum registro encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGradientEnd.withOpacity(0.1),
      appBar: AppBar(
        title: Text(
          'Relatório Completo - ${widget.nomeLavoura}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_dadosLavoura != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _gerarPDF,
              tooltip: 'Gerar PDF',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Carregando dados da lavoura...'),
                  ],
                ),
              )
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _carregarDados,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : _dadosLavoura == null
              ? const Center(child: Text('Nenhum dado disponível'))
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resumo geral
                    Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.agriculture,
                                  color: AppColors.primaryGreen,
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Resumo Geral - ${widget.nomeLavoura}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildInfoCard(
                              'Total de Plantios',
                              '${_dadosLavoura!['totalPlantios']}',
                              Icons.eco,
                              Colors.green,
                            ),
                            _buildInfoCard(
                              'Aplicações de Agrotóxicos',
                              '${_dadosLavoura!['totalAplicacoesAgrotoxicos']}',
                              Icons.pest_control,
                              Colors.red,
                            ),
                            _buildInfoCard(
                              'Aplicações de Insumos',
                              '${_dadosLavoura!['totalAplicacoesInsumos']}',
                              Icons.science,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Seção de Plantios
                    _buildSection(
                      'Plantios',
                      Icons.eco,
                      Colors.green,
                      (_dadosLavoura!['plantios'] as List<PlantioDto>)
                          .map((plantio) => _buildPlantioCard(plantio))
                          .toList(),
                    ),

                    // Seção de Aplicações de Agrotóxicos
                    _buildSection(
                      'Aplicações de Agrotóxicos',
                      Icons.pest_control,
                      Colors.red,
                      (_dadosLavoura!['aplicacoesAgrotoxicos']
                              as List<AplicacaoDto>)
                          .map(
                            (aplicacao) =>
                                _buildAplicacaoCard(aplicacao, 'Agrotóxico'),
                          )
                          .toList(),
                    ),

                    // Seção de Aplicações de Insumos
                    _buildSection(
                      'Aplicações de Insumos',
                      Icons.science,
                      Colors.blue,
                      (_dadosLavoura!['aplicacoesInsumos']
                              as List<AplicacaoDto>)
                          .map(
                            (aplicacao) =>
                                _buildAplicacaoCard(aplicacao, 'Insumo'),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
