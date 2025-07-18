import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/views/ForneAgrotoxico/FornecedorAgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/TipoAgrotoxico/TipoAgrotoxicoListView.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'AgrotoxicoFormView.dart';

class AgrotoxicoListView extends StatelessWidget {
  const AgrotoxicoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgrotoxicoViewModel>(context);
    final tipoViewModel = Provider.of<TipoAgrotoxicoViewModel>(
      context,
      listen: false,
    );
    final fornecedorViewModel = Provider.of<ForneAgrotoxicoViewModel>(
      context,
      listen: false,
    );

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(AgrotoxicoModel agrotoxico) {
      String formatarData(DateTime? data) {
        if (data == null) return 'N/A';
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
                    buildFutureDetailItem(
                      icon: Icons.category,
                      label: 'Tipo',
                      future: tipoViewModel.getID(agrotoxico.tipoID!),
                      onData: (data) => data.descricao,
                    ),
                  if (agrotoxico.fornecedorID != null)
                    buildFutureDetailItem(
                      icon: Icons.business,
                      label: 'Fornecedor',
                      future: fornecedorViewModel.getID(
                        agrotoxico.fornecedorID!,
                      ),
                      onData: (data) => data.nome,
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
      appBar: AppBar(title: const Text('Agrotóxicos')),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        color: primaryColor,
        child:
            viewModel.isLoading && viewModel.lista.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : viewModel.lista.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhum agrotóxico cadastrado.\nToque no botão "+" para adicionar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        return await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text(
                                  'Deseja realmente excluir ${item.nome}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (_) {
                        if (item.id != null) {
                          viewModel.delete(item.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.nome} excluído.'),
                              backgroundColor: errorColor,
                            ),
                          );
                        }
                      },
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
                          onTap: () => showDetailsDialog(item),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.1),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'tipoFAB',
            mini: true,
            backgroundColor: Colors.deepPurple,
            tooltip: 'Ver Tipos de Agrotóxico',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TipoAgrotoxicoListView(),
                ),
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
                MaterialPageRoute(
                  builder: (_) => FornecedorAgrotoxicoListView(),
                ),
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
                MaterialPageRoute(builder: (_) => const AgrotoxicoFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
