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
    _loadData();
  }

  Future<void> _loadData() async {
  final movimentacaoVM =
      Provider.of<MovimentacaoEstoqueViewModel>(context, listen: false);

  await Future.wait([
    Provider.of<AgrotoxicoViewModel>(context, listen: false).fetch(),
    Provider.of<SementeViewModel>(context, listen: false).fetch(),
    Provider.of<InsumoViewModel>(context, listen: false).fetch(),
  ]);

  await movimentacaoVM.fetchByLavoura(widget.lavouraId);
}


  String _getItemNome(
    BuildContext context,
    int? agrotoxicoID,
    int? sementeID,
    int? insumoID,
  ) {
    if (agrotoxicoID != null) {
      final lista =
          Provider.of<AgrotoxicoViewModel>(context, listen: false).lista;
      final item = lista.where((a) => a.id == agrotoxicoID).toList();
      return item.isNotEmpty ? item.first.nome : 'Agrotóxico #$agrotoxicoID';
    }
    if (sementeID != null) {
      final lista =
          Provider.of<SementeViewModel>(context, listen: false).semente;
      final item = lista.where((s) => s.id == sementeID).toList();
      return item.isNotEmpty ? item.first.nome : 'Semente #$sementeID';
    }
    if (insumoID != null) {
      final lista = Provider.of<InsumoViewModel>(context, listen: false).insumo;
      final item = lista.where((i) => i.id == insumoID).toList();
      return item.isNotEmpty ? item.first.nome : 'Insumo #$insumoID';
    }
    return 'Item desconhecido';
  }

  String _getTipoItem(int? agrotoxicoID, int? sementeID, int? insumoID) {
    if (agrotoxicoID != null) return 'Agrotóxico';
    if (sementeID != null) return 'Semente';
    if (insumoID != null) return 'Insumo';
    return 'N/A';
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
        final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(
          context,
          listen: false,
        );

        final success = await movimentacaoVM.delete(id);

        if (success) {
          if (!mounted) return;
          _showSuccess('Movimentação excluída com sucesso!');
        } else {
          if (!mounted) return;
          _showError(
            movimentacaoVM.errorMessage ?? 'Erro ao excluir movimentação',
          );
        }
      } catch (e) {
        if (!mounted) return;
        _showError('Erro ao excluir: $e');
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentações de Estoque'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child:
            movimentacaoVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : movimentacaoVM.hasError
                ? _buildErrorWidget(movimentacaoVM)
                : movimentacaoVM.lista.isEmpty
                ? _buildEmptyWidget()
                : _buildMovimentacoesList(movimentacaoVM),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
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
            _loadData();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Nova Movimentação',
      ),
    );
  }

  Widget _buildErrorWidget(MovimentacaoEstoqueViewModel movimentacaoVM) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar dados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movimentacaoVM.errorMessage ?? 'Erro desconhecido',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma movimentação encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clique no botão + para criar uma nova movimentação',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMovimentacoesList(MovimentacaoEstoqueViewModel movimentacaoVM) {
    return ListView.builder(
      reverse: true,
      itemCount: movimentacaoVM.lista.length,
      itemBuilder: (context, index) {
        final mov = movimentacaoVM.lista[index];
        final itemNome = _getItemNome(
          context,
          mov.agrotoxicoID,
          mov.sementeID,
          mov.insumoID,
        );
        final tipoItem = _getTipoItem(
          mov.agrotoxicoID,
          mov.sementeID,
          mov.insumoID,
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    mov.movimentacao == 1 ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                mov.movimentacao == 1
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: mov.movimentacao == 1 ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              itemNome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            mov.movimentacao == 1
                                ? Colors.green[100]
                                : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mov.movimentacao == 1 ? 'ENTRADA' : 'SAÍDA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:
                              mov.movimentacao == 1
                                  ? Colors.green[700]
                                  : Colors.red[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tipoItem,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantidade: ${mov.qtde.toStringAsFixed(2)} kg/L',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(mov.dataHora),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (mov.descricao != null && mov.descricao!.isNotEmpty)
                  Text(
                    mov.descricao!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            trailing:
                 null,
          ),
        );
      },
    );
  }
}
