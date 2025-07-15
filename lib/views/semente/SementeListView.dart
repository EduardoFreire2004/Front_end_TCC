import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FonecedorSementeListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeFormView.dart';
import 'package:provider/provider.dart';

class SementeListView extends StatelessWidget {
  const SementeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final sementeVM = Provider.of<SementeViewModel>(context);
    final fornecedorVM = Provider.of<ForneSementeViewModel>(
      context,
      listen: false,
    );

    final primaryColor = Colors.green[700]!;
    final errorColor = Colors.redAccent;
    final titleColor = Colors.green[800]!;
    final subtitleColor = Colors.grey[700]!;
    final scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(SementeModel semente) {
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
                    FutureBuilder(
                      future: fornecedorVM.getID(semente.fornecedorSementeID),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Fornecedor: Carregando...");
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Text("Fornecedor: ${snapshot.data!.nome}");
                        }
                        return const Text("Fornecedor: Não encontrado");
                      },
                    ),
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
      appBar: AppBar(title: const Text("Sementes")),
      body: RefreshIndicator(
        onRefresh: () => sementeVM.fetch(),
        color: primaryColor,
        child:
            sementeVM.isLoading && sementeVM.semente.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : sementeVM.semente.isEmpty
                ? Center(child: Text("Nenhuma semente cadastrada."))
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
                        return await showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Confirmar exclusão"),
                                content: Text(
                                  "Excluir a semente ${semente.nome}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text(
                                      "Excluir",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (_) {
                        sementeVM.delete(semente.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${semente.nome} excluída."),
                            backgroundColor: errorColor,
                          ),
                        );
                      },
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
            heroTag: 'fornecedorFAB',
            mini: true,
            backgroundColor: Colors.teal,
            tooltip: 'Ver Fornecedores de Sementes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FornecedorSementeListView(),
                ),
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
                MaterialPageRoute(builder: (_) => SementeFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
