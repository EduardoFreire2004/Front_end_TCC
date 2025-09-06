import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/services/aplicacao_service.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoFormView.dart';
import 'package:flutter_fgl_1/widgets/RelatorioButton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AplicacaoListView extends StatefulWidget {
  final int lavouraId;

  const AplicacaoListView({super.key, required this.lavouraId});

  @override
  State<AplicacaoListView> createState() => _AplicacaoListViewState();
}

class _AplicacaoListViewState extends State<AplicacaoListView> {
  final AplicacaoService _aplicacaoService = AplicacaoService();
  List<AplicacaoModel> _aplicacoes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarAplicacoes();
  }

  Future<void> _carregarAplicacoes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final aplicacoes = await _aplicacaoService
          .buscarAplicacoesAgrotoxicoPorLavoura(widget.lavouraId);
      setState(() {
        _aplicacoes = aplicacoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _excluirAplicacao(AplicacaoModel aplicacao) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text(
              'Tem certeza que deseja excluir esta aplicação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Excluir'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );

    if (confirmacao == true) {
      try {
        await _aplicacaoService.excluirAplicacaoAgrotoxico(aplicacao.id!);
        await _carregarAplicacoes(); // Recarregar lista

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aplicação excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final agrotoxicoVM = Provider.of<AgrotoxicoViewModel>(
      context,
      listen: false,
    );

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    void showDetailsDialog(AplicacaoModel aplicacao) async {
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

      final agrotoxico = await agrotoxicoVM.getID(aplicacao.agrotoxicoID);
      final nomeAgrotoxico = agrotoxico?.nome ?? 'Não encontrado';

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
                    Icons.calendar_today,
                    'Data e Hora',
                    formatarDataHora(aplicacao.dataHora),
                  ),
                  buildDetailItem(Icons.science, 'Agrotóxico', nomeAgrotoxico),
                  buildDetailItem(
                    Icons.scale,
                    'Quantidade',
                    '${aplicacao.qtde} ${agrotoxico?.unidade_Medida ?? ''}',
                  ),
                  if (aplicacao.lavouraNome != null)
                    buildDetailItem(
                      Icons.grass,
                      'Lavoura',
                      aplicacao.lavouraNome!,
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text('Aplicações de Agrotóxicos'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _carregarAplicacoes,
        color: primaryColor,
        child:
            _isLoading && _aplicacoes.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _aplicacoes.isEmpty
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
                  itemCount: _aplicacoes.length,
                  itemBuilder: (context, index) {
                    final item = _aplicacoes[index];
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
                                        await _excluirAplicacao(item);
                                        Navigator.of(context).pop(true);
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
                                              (_) => AplicacaoFormView(
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
          RelatorioButton(texto: 'Relatórios', icone: Icons.picture_as_pdf),
          const SizedBox(height: 12),
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
            backgroundColor: Colors.green,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AplicacaoFormView(lavouraId: widget.lavouraId),
                  ),
                ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
