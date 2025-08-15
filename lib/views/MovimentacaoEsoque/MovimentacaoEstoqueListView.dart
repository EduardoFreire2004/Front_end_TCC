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

  @override
  Widget build(BuildContext context) {
    final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentações de Estoque'),
        backgroundColor: Colors.green[700],
      ),
      body:
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
                    mov.agrotoxicoID,
                    mov.sementeID,
                    mov.insumoID,
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
                            '${_getTipoMovimentacao(mov.movimentacao)} • Qtde: ${mov.qtde}',
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(mov.dataHora),
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (mov.descricao.isNotEmpty)
                            Text(
                              mov.descricao,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                },
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
          if (result == true) {
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
