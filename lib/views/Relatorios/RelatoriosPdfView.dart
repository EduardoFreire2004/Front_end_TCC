import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/services/auth_service.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';

class RelatoriosPdfView extends StatefulWidget {
  final int lavouraId;
  final String lavouraNome;

  const RelatoriosPdfView({
    Key? key,
    required this.lavouraId,
    required this.lavouraNome,
  }) : super(key: key);

  @override
  State<RelatoriosPdfView> createState() => _RelatoriosPdfViewState();
}

class _RelatoriosPdfViewState extends State<RelatoriosPdfView> {
  String? _selectedReportType;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _isGenerating = false;
  String? _errorMessage;
  dynamic _currentRelatorio;
  late RelatorioService _relatorioService;

  final List<String> _reportTypes = [
    'plantios',
    'aplicacoes-agrotoxicos',
    'aplicacoes-insumos',
    'colheitas',
    'custos',
    'estoque',
    'sementes',
    'insumos',
    'agrotoxicos',
  ];

  final Map<String, String> _reportTypeNames = {
    'plantios': 'Relatório de Plantios',
    'aplicacoes-agrotoxicos': 'Relatório de Aplicações de Agrotóxicos',
    'aplicacoes-insumos': 'Relatório de Aplicações de Insumos',
    'colheitas': 'Relatório de Colheitas',
    'custos': 'Relatório de Custos',
    'estoque': 'Relatório de Estoque',
    'sementes': 'Relatório de Sementes',
    'insumos': 'Relatório de Insumos',
    'agrotoxicos': 'Relatório de Agrotóxicos',
  };

  @override
  void initState() {
    super.initState();
    _relatorioService = RelatorioService();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[600]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  Future<void> _generateReport() async {
    if (_selectedReportType == null ||
        _dataInicio == null ||
        _dataFim == null) {
      setState(() {
        _errorMessage = 'Selecione o tipo de relatório e as datas';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _currentRelatorio = null;
    });

    try {
      // Obter o ID do usuário logado
      final usuario = AuthService.usuario;
      if (usuario?.id == null) {
        setState(() {
          _errorMessage = 'Usuário não autenticado. Faça login novamente.';
        });
        return;
      }

      final usuarioId = usuario!.id!;

      // Testar conectividade primeiro
      final isConnected = await _relatorioService.testarConectividade();
      if (!isConnected) {
        setState(() {
          _errorMessage =
              'Não foi possível conectar com o servidor. Verifique se o backend está rodando e se a URL está correta.';
        });
        return;
      }
      switch (_selectedReportType) {
        case 'plantios':
          _currentRelatorio = await _relatorioService.gerarRelatorioPlantios(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'aplicacoes-agrotoxicos':
          _currentRelatorio = await _relatorioService.gerarRelatorioAgrotoxicos(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'aplicacoes-insumos':
          _currentRelatorio = await _relatorioService
              .gerarRelatorioInsumosEstoque(
                usuarioId: usuarioId,
                dataInicio: _dataInicio!,
                dataFim: _dataFim!,
              );
          break;
        case 'colheitas':
          _currentRelatorio = await _relatorioService.gerarRelatorioColheitas(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'custos':
          _currentRelatorio = await _relatorioService.gerarRelatorioCustos(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'estoque':
          _currentRelatorio = await _relatorioService.gerarRelatorioEstoque(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'sementes':
          _currentRelatorio = await _relatorioService.gerarRelatorioSementes(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'insumos':
          _currentRelatorio = await _relatorioService
              .gerarRelatorioInsumosEstoque(
                usuarioId: usuarioId,
                dataInicio: _dataInicio!,
                dataFim: _dataFim!,
              );
          break;
        case 'agrotoxicos':
          _currentRelatorio = await _relatorioService
              .gerarRelatorioAgrotoxicosEstoque(
                usuarioId: usuarioId,
                dataInicio: _dataInicio!,
                dataFim: _dataFim!,
              );
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Relatório gerado com sucesso!'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao gerar relatório: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Widget _buildRelatorioGeral(RelatorioGeralDto relatorio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Lavoura', relatorio.lavoura.nome),
        _buildInfoCard(
          'Área',
          '${relatorio.lavoura.area.toStringAsFixed(2)} ha',
        ),
        _buildInfoCard(
          'Período',
          '${relatorio.periodo.inicio} - ${relatorio.periodo.fim}',
        ),
        _buildInfoCard(
          'Total de Plantios',
          relatorio.resumo.totalPlantios.toString(),
        ),
        _buildInfoCard(
          'Total de Aplicações de Agrotóxicos',
          relatorio.resumo.totalAplicacoesAgrotoxicos.toString(),
        ),
        _buildInfoCard(
          'Total de Aplicações de Insumos',
          relatorio.resumo.totalAplicacoesInsumos.toString(),
        ),
        _buildInfoCard(
          'Total de Colheitas',
          relatorio.resumo.totalColheitas.toString(),
        ),
        _buildInfoCard(
          'Custo Total',
          'R\$ ${relatorio.resumo.custoTotal.toStringAsFixed(2)}',
        ),
        if (relatorio.resumo.receitaTotal != null)
          _buildInfoCard(
            'Receita Total',
            'R\$ ${relatorio.resumo.receitaTotal!.toStringAsFixed(2)}',
          ),
        if (relatorio.resumo.lucroEstimado != null)
          _buildInfoCard(
            'Lucro Estimado',
            'R\$ ${relatorio.resumo.lucroEstimado!.toStringAsFixed(2)}',
          ),
      ],
    );
  }

  Widget _buildRelatorioPlantios(RelatorioPlantiosDto relatorio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Lavoura', relatorio.lavoura.nome),
        _buildInfoCard('Período', relatorio.estatisticas.periodoAnalisado),
        _buildInfoCard(
          'Total de Plantios',
          relatorio.estatisticas.totalPlantios.toString(),
        ),
        _buildInfoCard(
          'Área Total Plantada',
          '${relatorio.estatisticas.areaTotalPlantada.toStringAsFixed(2)} ha',
        ),
        const SizedBox(height: 16),
        const Text(
          'Plantios:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.plantios.map((plantio) => _buildPlantioCard(plantio)),
      ],
    );
  }

  Widget _buildRelatorioAplicacoesResponse(
    RelatorioAplicacoesResponseDto relatorio,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          'Total de Registros',
          relatorio.totalRegistros.toString(),
        ),
        if (relatorio.error != null) _buildInfoCard('Erro', relatorio.error!),
        const SizedBox(height: 16),
        const Text(
          'Aplicações:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.data.map((aplicacao) => _buildAplicacaoCardNew(aplicacao)),
      ],
    );
  }

  Widget _buildAplicacaoCardNew(AplicacaoDto aplicacao) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(aplicacao.produto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lavoura: ${aplicacao.lavoura}'),
            Text('Data: ${aplicacao.dataAplicacao.split('T')[0]}'),
            Text('Observações: ${aplicacao.observacoes}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${aplicacao.quantidade.toStringAsFixed(2)} ${aplicacao.unidadeMedida}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatorioColheitas(RelatorioColheitasDto relatorio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Lavoura', relatorio.lavoura.nome),
        _buildInfoCard(
          'Total de Colheitas',
          relatorio.estatisticas.totalColheitas.toString(),
        ),
        _buildInfoCard(
          'Área Total Colhida',
          '${relatorio.estatisticas.areaTotalColhida.toStringAsFixed(2)} ha',
        ),
        _buildInfoCard(
          'Quantidade Total',
          '${relatorio.estatisticas.quantidadeTotal.toStringAsFixed(2)} ton',
        ),
        _buildInfoCard(
          'Produtividade Média',
          '${relatorio.estatisticas.produtividadeMedia.toStringAsFixed(2)} ton/ha',
        ),
        const SizedBox(height: 16),
        const Text(
          'Colheitas:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.colheitas.map((colheita) => _buildColheitaCard(colheita)),
      ],
    );
  }

  Widget _buildRelatorioCustos(RelatorioCustosDto relatorio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Lavoura', relatorio.lavoura.nome),
        _buildInfoCard('Período', relatorio.estatisticas.periodoAnalisado),
        _buildInfoCard(
          'Total de Custos',
          relatorio.estatisticas.totalCustos.toString(),
        ),
        _buildInfoCard(
          'Custo Total',
          'R\$ ${relatorio.estatisticas.totalCustos.toStringAsFixed(2)}',
        ),
        if (relatorio.estatisticas.custoPorHectare != null)
          _buildInfoCard(
            'Custo por Hectare',
            'R\$ ${relatorio.estatisticas.custoPorHectare!.toStringAsFixed(2)}',
          ),
        const SizedBox(height: 16),
        const Text(
          'Custos por Categoria:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.estatisticas.categorias.entries.map(
          (entry) => _buildInfoCard(
            entry.key,
            'R\$ ${entry.value.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Custos Detalhados:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.custos.map((custo) => _buildCustoCard(custo)),
      ],
    );
  }

  Widget _buildRelatorioEstoque(RelatorioEstoqueDto relatorio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Lavoura', relatorio.lavoura.nome),
        _buildInfoCard(
          'Total de Entradas',
          relatorio.estatisticas.totalEntradas.toString(),
        ),
        _buildInfoCard(
          'Total de Saídas',
          relatorio.estatisticas.totalSaidas.toString(),
        ),
        _buildInfoCard(
          'Produtos em Estoque',
          relatorio.estatisticas.produtosEmEstoque.toString(),
        ),
        if (relatorio.estatisticas.valorEstoque != null)
          _buildInfoCard(
            'Valor do Estoque',
            'R\$ ${relatorio.estatisticas.valorEstoque!.toStringAsFixed(2)}',
          ),
        const SizedBox(height: 16),
        const Text(
          'Saldo Atual:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.saldoAtual.entries.map(
          (entry) => _buildInfoCard(entry.key, '${entry.value} kg'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Movimentações:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 8),
        ...relatorio.movimentacoes.map((mov) => _buildMovimentacaoCard(mov)),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
        title: Text(plantio.cultura),
        subtitle: Text(
          'Data: ${plantio.dataPlantio} - Área: ${plantio.areaPlantada.toStringAsFixed(2)} ha',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            plantio.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColheitaCard(ColheitaDto colheita) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(colheita.cultura),
        subtitle: Text(
          'Data: ${colheita.dataColheita} - Área: ${colheita.areaColhida.toStringAsFixed(2)} ha',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${colheita.quantidadeColhida.toStringAsFixed(2)} ton',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              '${colheita.produtividade.toStringAsFixed(2)} ton/ha',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustoCard(CustoDto custo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(custo.descricao),
        subtitle: Text('Data: ${custo.data.toString().split(' ')[0]}'),
        trailing: Text(
          'R\$ ${custo.valor.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildMovimentacaoCard(MovimentacaoDto movimentacao) {
    final isEntrada = movimentacao.tipo == 'entrada';
    final color = isEntrada ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(movimentacao.produto),
        subtitle: Text(
          'Tipo: ${movimentacao.tipo} - Data: ${movimentacao.data}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${movimentacao.quantidade.toStringAsFixed(2)} ${movimentacao.unidade}',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                movimentacao.tipo.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios - ${widget.lavouraNome}'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleção do tipo de relatório
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assessment,
                          color: Colors.green[600],
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tipo de Relatório',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedReportType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Selecione o tipo de relatório',
                        prefixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.green[600],
                        ),
                      ),
                      items:
                          _reportTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(_reportTypeNames[type]!),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReportType = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seleção de datas
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[600],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Data Início',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[50],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _dataInicio != null
                                        ? '${_dataInicio!.day}/${_dataInicio!.month}/${_dataInicio!.year}'
                                        : 'Selecionar data',
                                    style: TextStyle(
                                      color:
                                          _dataInicio != null
                                              ? Colors.black
                                              : Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        _dataInicio != null
                                            ? Colors.blue[600]
                                            : Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[600],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Data Fim',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[50],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _dataFim != null
                                        ? '${_dataFim!.day}/${_dataFim!.month}/${_dataFim!.year}'
                                        : 'Selecionar data',
                                    style: TextStyle(
                                      color:
                                          _dataFim != null
                                              ? Colors.black
                                              : Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        _dataFim != null
                                            ? Colors.blue[600]
                                            : Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botão de gerar relatório
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                icon:
                    _isGenerating
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.assessment, size: 28),
                label: Text(
                  _isGenerating ? 'Gerando...' : 'Gerar Relatório',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Mensagem de erro
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Exibição do relatório
            if (_currentRelatorio != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assessment,
                            color: Colors.green[600],
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _reportTypeNames[_selectedReportType!]!,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_currentRelatorio is RelatorioGeralDto)
                        _buildRelatorioGeral(_currentRelatorio)
                      else if (_currentRelatorio is RelatorioPlantiosDto)
                        _buildRelatorioPlantios(_currentRelatorio)
                      else if (_currentRelatorio
                          is RelatorioAplicacoesResponseDto)
                        _buildRelatorioAplicacoesResponse(_currentRelatorio)
                      else if (_currentRelatorio is RelatorioColheitasDto)
                        _buildRelatorioColheitas(_currentRelatorio)
                      else if (_currentRelatorio is RelatorioCustosDto)
                        _buildRelatorioCustos(_currentRelatorio)
                      else if (_currentRelatorio is RelatorioEstoqueDto)
                        _buildRelatorioEstoque(_currentRelatorio),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
