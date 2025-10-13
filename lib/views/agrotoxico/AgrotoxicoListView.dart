import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/repositories/AgrotoxicoRepo.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/services/pdf_service.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
import 'package:flutter_fgl_1/views/TipoAgrotoxico/TipoAgrotoxicoListView.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'AgrotoxicoFormView.dart';

class AgrotoxicoListView extends StatefulWidget {
  const AgrotoxicoListView({super.key});

  @override
  State<AgrotoxicoListView> createState() => _AgrotoxicoListViewState();
}

class _AgrotoxicoListViewState extends State<AgrotoxicoListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgrotoxicoViewModel>(context);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;
    
    final AgrotoxicoRepo _repository = AgrotoxicoRepo();

    void showDetailsDialog(
      BuildContext context,
      AgrotoxicoModel agrotoxico,
    ) async {
      final tipoVM = Provider.of<TipoAgrotoxicoViewModel>(
        context,
        listen: false,
      );
      final fornecedorVM = Provider.of<FornecedoresViewModel>(
        context,
        listen: false,
      );

      final tipo = await tipoVM.getID(agrotoxico.tipoID);
      final fornecedor = await fornecedorVM.getID(agrotoxico.fornecedorID);

      if (!context.mounted) return;

      String formatarData(DateTime data) {
        return DateFormat('dd/MM/yyyy').format(data);
      }

      Widget buildDetailItem(IconData icon, String label, Widget value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Text(
                "$label: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              Expanded(child: value),
            ],
          ),
        );
      }

      Widget buildFutureDetailItem({
        required IconData icon,
        required String label,
        required Future<dynamic> future,
        required String Function(dynamic) onData,
      }) {
        return FutureBuilder<dynamic>(
          future: future,
          builder: (context, snapshot) {
            Widget valueWidget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              valueWidget = const Text(
                "Carregando...",
                style: TextStyle(fontStyle: FontStyle.italic),
              );
            } else if (snapshot.hasError) {
              valueWidget = const Text(
                "Erro ao buscar",
                style: TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              valueWidget = Text(onData(snapshot.data));
            } else {
              valueWidget = const Text("Não encontrado");
            }
            return buildDetailItem(icon, label, valueWidget);
          },
        );
      }

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              agrotoxico.nome,
              style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailItem(
                    Icons.calendar_today,
                    'Cadastro',
                    Text(formatarData(agrotoxico.data_Cadastro)),
                  ),
                  buildDetailItem(
                    Icons.scale,
                    'Quantidade',
                    Text('${agrotoxico.qtde} ${agrotoxico.unidade_Medida}'),
                  ),
                  if (agrotoxico.tipoID != null)
                    buildDetailItem(
                      Icons.category,
                      'Tipo',
                      Text(tipo?.descricao ?? 'Não encontrado'),
                    ),
                  if (agrotoxico.fornecedorID != null)
                    buildDetailItem(
                      Icons.business,
                      'Fornecedor',
                      Text(fornecedor?.nome ?? 'Não encontrado'),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('Fechar', style: TextStyle(color: primaryColor)),
              ),
            ],
          );
        },
      );
    }

    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text('Agrotóxicos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.fetch();
                } else {
                  viewModel.fetchByNome(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        color: primaryColor,
        child: Column(
          children: [
            Expanded(
              child:
                  viewModel.isLoading && viewModel.lista.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                      : viewModel.lista.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'Nenhum agrotóxico cadastrado.\nToque no botão "+" para adicionar.'
                                : 'Nenhum agrotóxico encontrado para "${_searchController.text}".',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: viewModel.lista.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.lista[index];
                          return Dismissible(
                            key: Key(item.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: errorColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: const Icon(
                                Icons.delete_sweep,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                        'Deseja realmente excluir este Agrotóxico?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (item.id != null) {
                                              await viewModel.delete(item.id!);
                                              Navigator.of(context).pop(true);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Agrotóxico excluído.',
                                                        ),
                                                        backgroundColor:
                                                            errorColor,
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              Navigator.of(context).pop(false);
                                            }
                                          },
                                          child: const Text(
                                            'Excluir',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                              return shouldDelete ?? false;
                            },
                            onDismissed: (_) {},
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () => showDetailsDialog(context, item),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: iconColor.withOpacity(
                                          0.1,
                                        ),
                                        child: Icon(
                                          Icons.science_outlined,
                                          color: iconColor,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.nome,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: titleColor,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              'Quantidade: ${item.qtde} ${item.unidade_Medida}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: subtitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey[600],
                                        ),
                                        tooltip: 'Editar Agrotóxico',
                                        onPressed:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => AgrotoxicoFormView(
                                                      agrotoxico: item,
                                                    ),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'relatorioFAB',
            mini: true,
            backgroundColor: Colors.blue[600],
            tooltip: 'Gerar Relatório PDF',
            
            onPressed: () async {
              final pdfService = PdfServiceLista();
              final _relatorioService = RelatorioService();
              try {
                final lista = await _relatorioService.getRelatorioAgrotoxico(); // Busca lista atualizada
                await pdfService.gerarRelatorio(
                  "Relatório de Agrotóxicos",
                  lista,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Relatório PDF de Agrotóxicos gerado com sucesso!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao gerar relatório: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },

            child: const Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'tipoFAB',
            mini: true,
            backgroundColor: Colors.deepPurple,
            tooltip: 'Ver Tipos de Agrotóxico',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TipoAgrotoxicoListView()),
              );
            },
            child: const Icon(Icons.category),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'fornecedorFAB',
            mini: true,
            backgroundColor: Colors.teal,
            tooltip: 'Ver Fornecedores de Agrotóxico',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FornecedoresListView()),
              );
            },
            child: const Icon(Icons.business),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addFAB',
            backgroundColor: Colors.green,
            tooltip: 'Adicionar Agrotóxico',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AgrotoxicoFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

