import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/MovimentacaoEstoqueViewModel.dart';
import '../../viewmodels/AgrotoxicoViewModel.dart';
import '../../viewmodels/SementeViewModel.dart';
import '../../viewmodels/InsumoViewModel.dart';
import 'MovimentacaoEstoqueFormView.dart';

class MovimentacaoEstoqueListView extends StatefulWidget {
  final int lavouraId;

  const MovimentacaoEstoqueListView({super.key, required this.lavouraId});

  @override
  State<MovimentacaoEstoqueListView> createState() =>
      _MovimentacaoEstoqueListViewState();
}

class _MovimentacaoEstoqueListViewState
    extends State<MovimentacaoEstoqueListView> {
  @override
  void initState() {
    super.initState();
    final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(
      context,
      listen: false,
    );
    movimentacaoVM.fetchByLavoura(widget.lavouraId);

    // Carregar nomes para exibir
    Provider.of<AgrotoxicoViewModel>(context, listen: false).fetch();
    Provider.of<SementeViewModel>(context, listen: false).fetch();
    Provider.of<InsumoViewModel>(context, listen: false).fetch();
  }

  String _getItemNome(
    BuildContext context,
    int agrotoxicoID,
    int sementeID,
    int insumoID,
  ) {
    if (agrotoxicoID != 0) {
      final lista =
          Provider.of<AgrotoxicoViewModel>(context, listen: false).lista;
      final item = lista.where((a) => a.id == agrotoxicoID).toList();
      return item.isNotEmpty ? item.first.nome : 'Agrotóxico #$agrotoxicoID';
    }
    if (sementeID != 0) {
      final lista =
          Provider.of<SementeViewModel>(context, listen: false).semente;
      final item = lista.where((s) => s.id == sementeID).toList();
      return item.isNotEmpty ? item.first.nome : 'Semente #$sementeID';
    }
    if (insumoID != 0) {
      final lista = Provider.of<InsumoViewModel>(context, listen: false).insumo;
      final item = lista.where((i) => i.id == insumoID).toList();
      return item.isNotEmpty ? item.first.nome : 'Insumo #$insumoID';
    }
    return 'Item desconhecido';
  }

  Future<void> _deleteMovimentacao(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text(
              'Tem certeza que deseja excluir esta movimentação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<MovimentacaoEstoqueViewModel>(
          context,
          listen: false,
        ).delete(id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimentação excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentações de Estoque'),
        backgroundColor: Colors.green[700],
      ),
      body: RefreshIndicator(
        onRefresh: () => movimentacaoVM.fetchByLavoura(widget.lavouraId),
        child:
            movimentacaoVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : movimentacaoVM.lista.isEmpty
                ? const Center(child: Text('Nenhuma movimentação encontrada.'))
                : ListView.builder(
                  itemCount: movimentacaoVM.lista.length,
                  itemBuilder: (context, index) {
                    final mov = movimentacaoVM.lista[index];
                    final itemNome = _getItemNome(
                      context,
                      mov.agrotoxicoID ?? 0,
                      mov.sementeID ?? 0,
                      mov.insumoID ?? 0,
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(
                          mov.movimentacao == 1
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                              mov.movimentacao == 1 ? Colors.green : Colors.red,
                        ),
                        title: Text(itemNome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${mov.movimentacao == 1 ? 'Entrada' : 'Saída'} • Qtde: ${mov.qtde}',
                            ),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(mov.dataHora),
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (mov.descricao.isNotEmpty)
                              Text(
                                mov.descricao,
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MovimentacaoEstoqueFormView(
                                        lavouraId: widget.lavouraId,
                                        movimentacao: mov,
                                      ),
                                ),
                              );
                              if (result == true && mounted) {
                                movimentacaoVM.fetchByLavoura(widget.lavouraId);
                              }
                            } else if (value == 'delete') {
                              await _deleteMovimentacao(mov.id!);
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Excluir'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      MovimentacaoEstoqueFormView(lavouraId: widget.lavouraId),
            ),
          );
          if (result == true && mounted) {
            Provider.of<MovimentacaoEstoqueViewModel>(
              context,
              listen: false,
            ).fetchByLavoura(widget.lavouraId);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
