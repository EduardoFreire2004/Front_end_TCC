import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeFormView.dart';
import 'package:provider/provider.dart';

class SementeListView extends StatefulWidget {
  const SementeListView({super.key});

  @override
  State<SementeListView> createState() => _SementeListViewState();
}

class _SementeListViewState extends State<SementeListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sementeVM = Provider.of<SementeViewModel>(context);
    final fornecedorVM = Provider.of<FornecedoresViewModel>(
      context,
      listen: false,
    );

    final primaryColor = Colors.green[700]!;
    final errorColor = Colors.redAccent;
    final titleColor = Colors.green[800]!;
    final subtitleColor = Colors.grey[700]!;
    final scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(SementeModel semente) async {
      final fornecedor = await fornecedorVM.getID(semente.fornecedorSementeID);

      if (!mounted) return;

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                semente.nome,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tipo: ${semente.tipo}"),
                    Text("Marca: ${semente.marca}"),
                    Text("Quantidade: ${semente.qtde}"),
                    Text("Preco: ${semente.preco}"),
                    Text("Fornecedor: ${fornecedor?.nome ?? "Não encontrado"}"),
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

    if (sementeVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sementeVM.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text("Sementes"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  sementeVM.fetch();
                } else {
                  sementeVM.fetchByNome(value);
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
        onRefresh: () => sementeVM.fetch(),
        color: primaryColor,
        child:
            sementeVM.isLoading && sementeVM.semente.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : sementeVM.semente.isEmpty
                ? const Center(child: Text("Nenhuma semente cadastrada."))
                : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: sementeVM.semente.length,
                  itemBuilder: (context, index) {
                    final semente = sementeVM.semente[index];
                    return Dismissible(
                      key: Key(semente.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: errorColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                  'Deseja realmente excluir esta Semente?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (semente.id != null) {
                                        await sementeVM.delete(semente.id!);
                                        Navigator.of(context).pop(true);
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Semente excluído.',
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
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Icon(Icons.grass, color: primaryColor),
                          ),
                          title: Text(
                            semente.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          subtitle: Text(
                            "Marca: ${semente.marca} - Qtde: ${semente.qtde}",
                          ),
                          onTap: () => showDetailsDialog(semente),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey[700]),
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            SementeFormView(semente: semente),
                                  ),
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
            heroTag: 'fornecedorFAB',
            mini: true,
            backgroundColor: Colors.teal,
            tooltip: 'Ver Fornecedores de Sementes',
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
            tooltip: 'Adicionar Semente',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SementeFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
