import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ColheitaModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ColheitaListView extends StatelessWidget {
  const ColheitaListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ColheitaViewModel>(context);
    final primaryColor = Colors.green[700]!;
    final errorColor = Colors.redAccent;

    void showDetailsDialog(ColheitaModel colheita) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(colheita.tipo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data: ${DateFormat('dd/MM/yyyy').format(colheita.dataHora)}'),
              const SizedBox(height: 8),
              Text('Descrição: ${colheita.descricao ?? "Sem descrição"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar', style: TextStyle(color: primaryColor)),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Colheitas')),
      body: viewModel.isLoading && viewModel.colheita.isEmpty
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : viewModel.colheita.isEmpty
              ? const Center(child: Text('Nenhuma colheita cadastrada.'))
              : ListView.builder(
                  itemCount: viewModel.colheita.length,
                  itemBuilder: (_, index) {
                    final colheita = viewModel.colheita[index];
                    return Dismissible(
                      key: Key(colheita.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: errorColor,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Deseja excluir esta colheita?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) => viewModel.delete(colheita.id!),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(colheita.tipo),
                          subtitle: Text(DateFormat('dd/MM/yyyy').format(colheita.dataHora)),
                          onTap: () => showDetailsDialog(colheita),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ColheitaFormView(colheita: colheita),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ColheitaFormView()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
