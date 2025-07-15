import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AplicacaoListView extends StatelessWidget {
  const AplicacaoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final aplicacaoVM = Provider.of<AplicacaoViewModel>(context);
    final agrotoxicoVM = Provider.of<AgrotoxicoViewModel>(context, listen: false);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(AplicacaoModel aplicacao) {
      String formatarDataHora(DateTime data) {
        return DateFormat('dd/MM/yyyy HH:mm').format(data);
      }

      Widget buildDetailItem(IconData icon, String label, String value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
              Expanded(child: Text(value)),
            ],
          ),
        );
      }

      Widget buildAgrotoxicoDetail(int agrotoxicoID) {
        return FutureBuilder<AgrotoxicoModel?>(
          future: agrotoxicoVM.getID(agrotoxicoID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildDetailItem(Icons.science, 'Agrotóxico', 'Carregando...');
            } else if (snapshot.hasError || snapshot.data == null) {
              return buildDetailItem(Icons.science, 'Agrotóxico', 'Não encontrado');
            } else {
              return buildDetailItem(Icons.science, 'Agrotóxico', snapshot.data!.nome);
            }
          },
        );
      }

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('Detalhes da Aplicação', style: TextStyle(color: titleColor)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailItem(Icons.description, 'Descrição', aplicacao.descricao),
                  buildDetailItem(Icons.calendar_today, 'Data e Hora', formatarDataHora(aplicacao.dataHora)),
                  buildAgrotoxicoDetail(aplicacao.agrotoxicoID),
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

    if (aplicacaoVM.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(aplicacaoVM.errorMessage!), backgroundColor: errorColor),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(title: const Text('Aplicações')),
      body: RefreshIndicator(
        onRefresh: () => aplicacaoVM.fetch(),
        color: primaryColor,
        child: aplicacaoVM.isLoading && aplicacaoVM.aplicacao.isEmpty
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : aplicacaoVM.aplicacao.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhuma aplicação registrada.\nToque no botão "+" para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: aplicacaoVM.aplicacao.length,
                    itemBuilder: (context, index) {
                      final item = aplicacaoVM.aplicacao[index];
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: Text('Deseja realmente excluir esta aplicação?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) {
                          if (item.id != null) {
                            aplicacaoVM.delete(item.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Aplicação excluída.'), backgroundColor: errorColor),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () => showDetailsDialog(item),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: iconColor.withOpacity(0.1),
                                    child: Icon(Icons.local_florist, color: iconColor),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          DateFormat('dd/MM/yyyy HH:mm').format(item.dataHora),
                                          style: TextStyle(fontSize: 14, color: subtitleColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blueGrey[600]),
                                    tooltip: 'Editar Aplicação',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AplicacaoFormView(aplicacao: item),
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
            heroTag: 'agrotoxicoFAB',
            mini: true,
            backgroundColor: Colors.orange[600],
            tooltip: 'Ver Agrotóxicos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AgrotoxicoListView()),
              );
            },
            child: const Icon(Icons.science_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addFAB',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AplicacaoFormView()),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
