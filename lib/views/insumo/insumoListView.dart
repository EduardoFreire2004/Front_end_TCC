import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/InsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/views/CategoriaInsumo/CategoriaInsumoListView.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
import 'package:flutter_fgl_1/views/Insumo/insumoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InsumoListView extends StatefulWidget {
  const InsumoListView({super.key});

  @override
  State<InsumoListView> createState() => _InsumoListViewState();
}

class _InsumoListViewState extends State<InsumoListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final insumoVM = Provider.of<InsumoViewModel>(context);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(BuildContext context, InsumoModel insumo) async {
      final categoriaVM = Provider.of<CategoriaInsumoViewModel>(
        context,
        listen: false,
      );
      final fornecedorVM = Provider.of<FornecedoresViewModel>(
        context,
        listen: false,
      );

      final categoria = await categoriaVM.getID(insumo.categoriaID);
      final fornecedor = await fornecedorVM.getID(insumo.fornecedorID);

      if (!context.mounted) return;

      String formatarData(DateTime data) {
        return DateFormat('dd/MM/yyyy').format(data);
      }

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Detalhes do Insumo',
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nome: ${insumo.nome}"),
                    Text("Quantidade: ${insumo.qtde}"),
                    Text("Unidade: ${insumo.unidade_Medida}"),
                    Text("Cadastro: ${formatarData(insumo.data_Cadastro)}"),
                    Text("Preco: ${insumo.preco}"),
                    Text(
                      "Categoria: ${categoria?.descricao ?? 'Não encontrada'}",
                    ),
                    Text("Fornecedor: ${fornecedor?.nome ?? 'Não encontrado'}"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fechar", style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
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
      appBar: AppBar(
        title: const Text('Insumos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  insumoVM.fetch();
                } else {
                  insumoVM.fetchByNome(value);
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
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                  'Deseja realmente excluir este Insumo?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (item.id != null) {
                                        await insumoVM.delete(item.id!);
                                        Navigator.of(context).pop(true);
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Insumo excluído.',
                                                  ),
                                                  backgroundColor: errorColor,
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
            heroTag: 'relatorioFAB',
            mini: true,
            backgroundColor: Colors.blue[600],
            tooltip: 'Gerar Relatório PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Funcionalidade de relatório será implementada via API',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'categoriaFAB',
            mini: true,
            backgroundColor: Colors.deepPurple,
            tooltip: 'Ver Categorias de Insumo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoriaInsumoListView()),
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
                MaterialPageRoute(builder: (_) => FornecedoresListView()),
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

