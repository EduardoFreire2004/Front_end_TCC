import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/InsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewModel.dart';
import 'package:flutter_fgl_1/views/CategoriaInsumo/CategoriaInsumoListView.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/Insumo/insumoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InsumoListView extends StatelessWidget {
  const InsumoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final insumoVM = Provider.of<InsumoViewModel>(context);
    final categoriaVM = Provider.of<CategoriaInsumoViewModel>(
      context,
      listen: false,
    );
    final fornecedorVM = Provider.of<ForneInsumoViewModel>(
      context,
      listen: false,
    );

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(InsumoModel insumo) {
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
              'Detalhes do Insumo',
              style: TextStyle(color: titleColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailItem(Icons.inventory, 'Nome', Text(insumo.nome)),
                  buildDetailItem(
                    Icons.scale,
                    'Quantidade',
                    Text(insumo.qtde.toString()),
                  ),
                  buildDetailItem(
                    Icons.straighten,
                    'Unidade',
                    Text(insumo.unidade_Medida),
                  ),
                  buildDetailItem(
                    Icons.calendar_today,
                    'Cadastro',
                    Text(formatarData(insumo.data_Cadastro)),
                  ),
                  buildFutureDetailItem(
                    icon: Icons.category,
                    label: 'Categoria',
                    future: categoriaVM.getID(insumo.categoriaID),
                    onData: (data) => data.descricao,
                  ),
                  buildFutureDetailItem(
                    icon: Icons.business,
                    label: 'Fornecedor',
                    future: fornecedorVM.getID(insumo.fornecedorID),
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

    if (insumoVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(insumoVM.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(title: const Text('Insumos')),
      body: RefreshIndicator(
        onRefresh: () => insumoVM.fetch(),
        color: primaryColor,
        child:
            insumoVM.isLoading && insumoVM.insumo.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : insumoVM.insumo.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhum insumo cadastrado.\nToque no botão "+" para adicionar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: insumoVM.insumo.length,
                  itemBuilder: (context, index) {
                    final item = insumoVM.insumo[index];
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
                                  'Deseja realmente excluir este insumo?',
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
                          insumoVM.delete(item.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Insumo excluído.'),
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
                                    Icons.inventory_2,
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
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(item.data_Cadastro),
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
                                  tooltip: 'Editar Insumo',
                                  onPressed:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  InsumoFormView(insumo: item),
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
            heroTag: 'categoriaFAB',
            mini: true,
            backgroundColor: Colors.deepPurple,
            tooltip: 'Ver Categorias de Insumo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriaInsumoListView(),
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
            tooltip: 'Ver Fornecedores de Insumo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FornecedorInsumoListView(),
                ),
              );
            },
            child: const Icon(Icons.business),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addFAB',
            backgroundColor: Colors.green,
            tooltip: 'Adicionar Insumo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InsumoFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
