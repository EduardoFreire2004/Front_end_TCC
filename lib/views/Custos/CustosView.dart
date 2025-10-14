import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fgl_1/viewmodels/CustoViewModel.dart';
import 'package:flutter_fgl_1/services/custo_service.dart';
import 'package:flutter_fgl_1/services/auth_service.dart';
import 'package:intl/intl.dart';

class CustosView extends StatefulWidget {
  final int lavouraId;
  final String nomeLavoura;

  const CustosView({
    super.key,
    required this.lavouraId,
    required this.nomeLavoura,
  });

  @override
  State<CustosView> createState() => _CustosViewState();
}

class _CustosViewState extends State<CustosView> with TickerProviderStateMixin {
  late TabController _tabController;
  late CustoViewModel _custoViewModel;
  DateTime? _dataInicio;
  DateTime? _dataFim;

  final Color primaryColor = Colors.green[700]!;
  final Color titleColor = Colors.green[800]!;
  final Color subtitleColor = Colors.grey[700]!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final token = AuthService.token;
    if (token != null) {
      final custoService = CustoService(token: token);
      _custoViewModel = CustoViewModel(custoService);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _custoViewModel.calcularCustosUltimoMes(widget.lavouraId);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context, bool isDataInicio) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate:
          isDataInicio
              ? _dataInicio ?? DateTime.now()
              : _dataFim ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        if (isDataInicio) {
          _dataInicio = dataSelecionada;
        } else {
          _dataFim = dataSelecionada;
        }
      });
    }
  }

  Future<void> _calcularCustos() async {
    if (_dataInicio != null && _dataFim != null) {
      if (_custoViewModel.validarDatas(_dataInicio, _dataFim)) {
        await _custoViewModel.calcularCustosLavoura(
          lavouraId: widget.lavouraId,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data de início deve ser anterior à data de fim'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione as datas de início e fim'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _custoViewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Custos - ${widget.nomeLavoura}'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.analytics), text: 'Resumo'),
              Tab(icon: Icon(Icons.list), text: 'Detalhes'),
              Tab(icon: Icon(Icons.history), text: 'Histórico'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed:
                  () =>
                      _custoViewModel.atualizarCustosLavoura(widget.lavouraId),
              tooltip: 'Atualizar Custos',
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Período de Análise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selecionarData(context, true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: subtitleColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _dataInicio != null
                                      ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_dataInicio!)
                                      : 'Data Início',
                                  style: TextStyle(
                                    color:
                                        _dataInicio != null
                                            ? titleColor
                                            : subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selecionarData(context, false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: subtitleColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _dataFim != null
                                      ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_dataFim!)
                                      : 'Data Fim',
                                  style: TextStyle(
                                    color:
                                        _dataFim != null
                                            ? titleColor
                                            : subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _calcularCustos,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calcular Custos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _dataInicio = null;
                            _dataFim = null;
                          });
                          _custoViewModel.calcularCustosUltimoMes(
                            widget.lavouraId,
                          );
                        },
                        icon: const Icon(Icons.today),
                        label: const Text('Último Mês'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildResumoTab(),
                  _buildDetalhesTab(),
                  _buildHistoricoTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoTab() {
    return Consumer<CustoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingCustos) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorCustos != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar custos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.errorCustos!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => viewModel.calcularCustosUltimoMes(widget.lavouraId),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (viewModel.custoAtual == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhum custo calculado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecione um período e calcule os custos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final custo = viewModel.custoAtual!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Custo Total do Período',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        viewModel.custoTotalFormatado,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (viewModel.dataInicio != null &&
                          viewModel.dataFim != null)
                        Text(
                          '${viewModel.formatarData(viewModel.dataInicio!)} - ${viewModel.formatarData(viewModel.dataFim!)}',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildCategoriaCard(
                    'Aplicações',
                    custo.custoAplicacoes,
                    viewModel.getPercentualCategoria(custo.custoAplicacoes),
                    Colors.orange,
                    Icons.science,
                  ),
                  _buildCategoriaCard(
                    'Insumos',
                    custo.custoAplicacoesInsumos,
                    viewModel.getPercentualCategoria(
                      custo.custoAplicacoesInsumos,
                    ),
                    Colors.blue,
                    Icons.eco,
                  ),
                  _buildCategoriaCard(
                    'Plantios',
                    custo.custoPlantios,
                    viewModel.getPercentualCategoria(custo.custoPlantios),
                    Colors.purple,
                    Icons.local_florist,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriaCard(
    String titulo,
    double valor,
    double percentual,
    Color cor,
    IconData icone,
  ) {
    return Consumer<CustoViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icone, color: cor, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.formatarMoeda(valor),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${percentual.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetalhesTab() {
    return Consumer<CustoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingCustos) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.custoAtual == null ||
            viewModel.custoAtual!.detalhes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhum detalhe disponível',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calcule os custos para ver os detalhes',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.custoAtual!.detalhes.length,
          itemBuilder: (context, index) {
            final detalhe = viewModel.custoAtual!.detalhes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: viewModel
                      .getCorCategoria(detalhe.categoria)
                      .withValues(alpha: 0.1),
                  child: Icon(
                    viewModel.getIconeCategoria(detalhe.categoria),
                    color: viewModel.getCorCategoria(detalhe.categoria),
                  ),
                ),
                title: Text(
                  detalhe.descricao,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      detalhe.categoria,
                      style: TextStyle(
                        color: viewModel.getCorCategoria(detalhe.categoria),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Data: ${viewModel.formatarData(detalhe.data)}',
                      style: TextStyle(color: subtitleColor),
                    ),
                    if (detalhe.produtoNome != null)
                      Text(
                        'Produto: ${detalhe.produtoNome}',
                        style: TextStyle(color: subtitleColor),
                      ),
                    if (detalhe.quantidade != null &&
                        detalhe.unidadeMedida != null)
                      Text(
                        'Quantidade: ${detalhe.quantidade} ${detalhe.unidadeMedida}',
                        style: TextStyle(color: subtitleColor),
                      ),
                  ],
                ),
                trailing: Text(
                  viewModel.formatarMoeda(detalhe.custo),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: viewModel.getCorCategoria(detalhe.categoria),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoricoTab() {
    return Consumer<CustoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingHistorico) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.historico.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhum histórico disponível',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Carregue o histórico de custos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed:
                      () => viewModel.obterHistoricoCustos(
                        lavouraId: widget.lavouraId,
                        dataInicio: _dataInicio,
                        dataFim: _dataFim,
                      ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Carregar Histórico'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.historico.length,
          itemBuilder: (context, index) {
            final item = viewModel.historico[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: viewModel
                      .getCorCategoria(item.tipoOperacao)
                      .withValues(alpha: 0.1),
                  child: Icon(
                    viewModel.getIconeCategoria(item.tipoOperacao),
                    color: viewModel.getCorCategoria(item.tipoOperacao),
                  ),
                ),
                title: Text(
                  item.descricao,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item.tipoOperacao,
                      style: TextStyle(
                        color: viewModel.getCorCategoria(item.tipoOperacao),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Data: ${viewModel.formatarData(item.data)}',
                      style: TextStyle(color: subtitleColor),
                    ),
                    if (item.produtoNome != null)
                      Text(
                        'Produto: ${item.produtoNome}',
                        style: TextStyle(color: subtitleColor),
                      ),
                    if (item.quantidade != null && item.unidadeMedida != null)
                      Text(
                        'Quantidade: ${item.quantidade} ${item.unidadeMedida}',
                        style: TextStyle(color: subtitleColor),
                      ),
                  ],
                ),
                trailing: Text(
                  viewModel.formatarMoeda(item.custo),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: viewModel.getCorCategoria(item.tipoOperacao),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
