import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AplicacaoInsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacaoInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/views/AplicacaoInsumo/AplicacaoInsumoFormView.dart';
import 'package:flutter_fgl_1/views/Insumo/InsumoListView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AplicacaoInsumoListView extends StatefulWidget {
  final int lavouraId;

  const AplicacaoInsumoListView({super.key, required this.lavouraId});

  @override
  State<AplicacaoInsumoListView> createState() => _AplicacaoListViewState();
}

class _AplicacaoListViewState extends State<AplicacaoInsumoListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AplicacaoInsumoViewModel>(
        context,
        listen: false,
      ).fetchByLavoura(widget.lavouraId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final aplicacaoVM = Provider.of<AplicacaoInsumoViewModel>(context);
    final insumoVM = Provider.of<InsumoViewModel>(context, listen: false);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(AplicacaoInsumoModel aplicacao) async {
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

      final insumo = await insumoVM.getID(aplicacao.insumoID);
      final nomeInsumo = insumo?.nome ?? 'Não encontrado';
      final unidadeMedidaInsumo = insumo?.unidade_Medida ?? 'Não Encontrado';

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Detalhes da Aplicação',
              style: TextStyle(color: titleColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailItem(
                    Icons.description,
                    'Descrição',
                    aplicacao.descricao ?? '',
                  ),
                  buildDetailItem(
                    Icons.scale,
                    'Quantidade',
                    '${aplicacao.qtde ?? 0} ${unidadeMedidaInsumo ?? ''}',
                  ),
                  buildDetailItem(
                    Icons.calendar_today,
                    'Data e Hora',
                    formatarDataHora(aplicacao.dataHora),
                  ),
                  buildDetailItem(Icons.science, 'Insumo', nomeInsumo),
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
          SnackBar(
            content: Text(aplicacaoVM.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
        aplicacaoVM.errorMessage = null; // ✅ limpa o erro após exibir
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(title: const Text('Aplicações de Insumos')),
      body: RefreshIndicator(
        onRefresh: () => aplicacaoVM.fetchByLavoura(widget.lavouraId),
        color: primaryColor,
        child:
            aplicacaoVM.isLoading && aplicacaoVM.aplicacao.isEmpty
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
                                  'Deseja realmente excluir esta Aplicação?',
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
                                        await aplicacaoVM.delete(
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
                                                    'Aplicação excluída.',
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
                          onTap: () => showDetailsDialog(item),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.local_florist,
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
                                        item.descricao ?? '',
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
                                  tooltip: 'Editar Aplicação',
                                  onPressed:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => AplicacaoInsumoFormView(
                                                aplicacao: item,
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
            heroTag: 'insumoFAB',
            mini: true,
            backgroundColor: Colors.orange[600],
            tooltip: 'Ver Insumos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InsumoListView()),
              );
            },
            child: const Icon(Icons.science_outlined),
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
                        (_) => AplicacaoInsumoFormView(
                          lavouraId: widget.lavouraId,
                        ),
                  ),
                ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
