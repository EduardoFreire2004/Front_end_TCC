import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ColheitaModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ColheitaListView extends StatefulWidget {
  final int lavouraId;

  const ColheitaListView({super.key, required this.lavouraId});

  @override
  State<ColheitaListView> createState() => _ColheitaListViewState();
}

class _ColheitaListViewState extends State<ColheitaListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColheitaViewModel>(
        context,
        listen: false,
      ).fetchByLavoura(widget.lavouraId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colheitaVM = Provider.of<ColheitaViewModel>(context);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(ColheitaModel colheita) {
      String formatarDataHora(DateTime data) =>
          DateFormat('dd/MM/yyyy HH:mm').format(data);

      String formatarReal(num valor) =>
          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);

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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              Expanded(child: Text(value)),
            ],
          ),
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
              'Detalhes da Colheita',
              style: TextStyle(color: titleColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailItem(Icons.category, 'Tipo', colheita.tipo),
                  buildDetailItem(
                    Icons.calendar_today,
                    'Data e Hora',
                    formatarDataHora(colheita.dataHora),
                  ),
                  if (colheita.descricao != null &&
                      colheita.descricao!.trim().isNotEmpty)
                    buildDetailItem(
                      Icons.description,
                      'Descrição',
                      colheita.descricao!,
                    ),
                  buildDetailItem(
                    Icons.shopping_bag,
                    'Quantidade de Sacas (60kg)',
                    colheita.quantidadeSacas.toStringAsFixed(2),
                  ),
                  buildDetailItem(
                    Icons.landscape,
                    'Área (hectares)',
                    colheita.areaHectares.toStringAsFixed(2),
                  ),
                  buildDetailItem(
                    Icons.store,
                    'Cooperativa de Destino',
                    colheita.cooperativaDestino,
                  ),
                  buildDetailItem(
                    Icons.monetization_on,
                    'Preço por Saca',
                    formatarReal(colheita.precoPorSaca),
                  ),
                  buildDetailItem(
                    Icons.show_chart,
                    'Rendimento por hectare',
                    colheita.areaHectares == 0
                        ? '0.00'
                        : (colheita.quantidadeSacas / colheita.areaHectares)
                            .toStringAsFixed(2),
                  ),
                  buildDetailItem(
                    Icons.attach_money,
                    'Rendimento financeiro',
                    formatarReal(colheita.quantidadeSacas * colheita.precoPorSaca),
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

    if (colheitaVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(colheitaVM.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(title: const Text('Colheitas')),
      body: RefreshIndicator(
        onRefresh: () => colheitaVM.fetchByLavoura(widget.lavouraId),
        color: primaryColor,
        child: colheitaVM.isLoading && colheitaVM.colheita.isEmpty
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : colheitaVM.colheita.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhuma colheita registrada.\nToque no botão "+" para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: colheitaVM.colheita.length,
                    itemBuilder: (context, index) {
                      final item = colheitaVM.colheita[index];
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
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text(
                                'Deseja realmente excluir esta colheita?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (item.id != null) {
                                      await colheitaVM.delete(
                                        item.id!,
                                        item.lavouraID,
                                      );
                                      Navigator.of(context).pop(true);
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Colheita excluída.'),
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
                            onTap: () => showDetailsDialog(item),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.tipo,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: titleColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(item.dataHora),
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
                                    tooltip: 'Editar Colheita',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ColheitaFormView(
                                          colheita: item,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ColheitaFormView(lavouraId: widget.lavouraId),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
