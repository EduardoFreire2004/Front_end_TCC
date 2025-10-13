import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/PlantioModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Plantio/PlantioFormView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlantioListView extends StatefulWidget {
  final int lavouraId;

  const PlantioListView({super.key, required this.lavouraId});

  @override
  State<PlantioListView> createState() => _PlantioListViewState();
}

class _PlantioListViewState extends State<PlantioListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlantioViewModel>(
        context,
        listen: false,
      ).fetchByLavoura(widget.lavouraId);
    });
  }

  void _showDetailsDialog(
    BuildContext pageContext,
    PlantioModel plantio,
  ) async {
    final sementeVM = Provider.of<SementeViewModel>(pageContext, listen: false);
    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color iconColor = Colors.green[700]!;

    String formatarDataHora(DateTime data) =>
        DateFormat('dd/MM/yyyy HH:mm').format(data);

    Widget buildDetailItem(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Text(
              "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
    }

    final semente = await sementeVM.getID(plantio.sementeID);
    final nomeSemente = semente?.nome ?? 'Não encontrada';

    showDialog(
      context: pageContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Detalhes do Plantio',
            style: TextStyle(color: titleColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildDetailItem(
                  Icons.description,
                  'Descrição',
                  plantio.descricao,
                ),
                buildDetailItem(Icons.scale, 
                  'Quantidade', 
                    '${plantio.qtde ?? 0}',),
                buildDetailItem(
                  Icons.map,
                  'Área Plantada',
                  "${plantio.areaPlantada.toStringAsFixed(2)} ha",
                ),
                buildDetailItem(
                  Icons.calendar_today,
                  'Data e Hora',
                  formatarDataHora(plantio.dataHora),
                ),
                buildDetailItem(Icons.grass, 'Semente', nomeSemente),
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

  @override
  Widget build(BuildContext context) {
    final plantioVM = Provider.of<PlantioViewModel>(context);
    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    if (plantioVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(plantioVM.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    final lista = plantioVM.plantio;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(title: const Text('Plantios')),
      body: RefreshIndicator(
        onRefresh: () => plantioVM.fetchByLavoura(widget.lavouraId),
        color: primaryColor,
        child:
            plantioVM.isLoading && lista.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : lista.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhum plantio registrado.\nToque no botão "+" para adicionar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final item = lista[index];
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
                                  'Deseja realmente excluir este Plantio?',
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
                                        await plantioVM.delete(
                                          item.id!,
                                          item.lavouraID,
                                        );
                                        Navigator.of(context).pop(true);
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Plantio excluído.',
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
                          onTap: () => _showDetailsDialog(context, item),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.agriculture,
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
                                        item.descricao,
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
                                          'dd/MM/yyyy HH:mm',
                                        ).format(item.dataHora),
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
                                  tooltip: 'Editar Plantio',
                                  onPressed:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => PlantioFormView(
                                                plantio: item,
                                                lavouraId: widget.lavouraId,
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
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'sementeFAB',
            mini: true,
            backgroundColor: Colors.orange[600],
            tooltip: 'Ver Sementes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SementeListView()),
              );
            },
            child: const Icon(Icons.grass_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addFAB',
            backgroundColor: Colors.green,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PlantioFormView(lavouraId: widget.lavouraId),
                  ),
                ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

