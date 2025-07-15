import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/PlantioModel.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Plantio/PlantioFormView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlantioListView extends StatelessWidget {
  const PlantioListView({super.key});

  @override
  Widget build(BuildContext context) {
    final plantioVM = Provider.of<PlantioViewModel>(context);
    final sementeVM = Provider.of<SementeViewModel>(context, listen: false);

    final Color primaryColor = Colors.green[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;

    void showDetailsDialog(PlantioModel plantio) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Detalhes do Plantio"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Descrição: ${plantio.descricao}"),
                  Text(
                    "Área Plantada: ${plantio.areaPlantada.toStringAsFixed(2)} ha",
                  ),
                  Text(
                    "Data/Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(plantio.dataHora)}",
                  ),
                  FutureBuilder<SementeModel?>(
                    future: sementeVM.getID(plantio.sementeID),
                    builder: (_, snapshot) {
                      final nome = snapshot.data?.nome ?? "Carregando...";
                      return Text("Semente: $nome");
                    },
                  ),
                ],
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

    return Scaffold(
      appBar: AppBar(title: const Text("Plantios")),
      body:
          plantioVM.isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : plantioVM.plantio.isEmpty
              ? Center(child: Text("Nenhum plantio registrado"))
              : ListView.builder(
                itemCount: plantioVM.plantio.length,
                itemBuilder: (_, index) {
                  final item = plantioVM.plantio[index];
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: errorColor,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss:
                        (_) => showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Excluir Plantio"),
                                content: const Text(
                                  "Deseja realmente excluir este plantio?",
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
                        ),
                    onDismissed: (_) {
                      if (item.id != null) {
                        plantioVM.delete(item.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Plantio excluído"),
                            backgroundColor: errorColor,
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: const Icon(Icons.agriculture),
                      title: Text(item.descricao),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(item.dataHora),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantioFormView(plantio: item),
                              ),
                            ),
                      ),
                      onTap: () => showDetailsDialog(item),
                    ),
                  );
                },
              ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'sementeFAB',
            mini: true,
            backgroundColor: Colors.deepPurple,
            tooltip: 'Ver Sementes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SementeListView(),
                ),
              );
            },
            child: const Icon(Icons.category),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addFAB',
            backgroundColor: Colors.green,
            tooltip: 'Adicionar Plantio',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlantioFormView()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
