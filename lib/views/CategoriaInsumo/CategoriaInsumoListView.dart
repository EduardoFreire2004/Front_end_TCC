import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/views/CategoriaInsumo/CategoriaInsumoFormView.dart';
import 'package:provider/provider.dart';

class CategoriaInsumoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoriaInsumoViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias de Insumos'),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: viewModel.isLoading && viewModel.categoriaInsumo.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : viewModel.categoriaInsumo.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhuma categoria cadastrada ainda.\nToque no botão "+" para adicionar.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: viewModel.categoriaInsumo.length,
                    itemBuilder: (context, index) {
                      final categoria = viewModel.categoriaInsumo[index];
                      return Dismissible(
                        key: Key(categoria.id.toString()),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          if (categoria.id != null) {
                            viewModel.delete(categoria.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${categoria.descricao} excluído.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          categoria.descricao ?? 'Nome não disponível',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.green[200] : Colors.green[800],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: isDark ? Colors.blue[200] : Colors.blueGrey[600]),
                                    tooltip: 'Editar Categoria',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoriaInsumoFormView(categoria: categoria),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CategoriaInsumoFormView()),
        ),
        tooltip: 'Adicionar Categoria',
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
