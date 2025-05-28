import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewmodel.dart';
import 'package:flutter_fgl_1/views/categoria_insumo/CategoriaInsumoFormView.dart';
import 'package:provider/provider.dart';

class CategoriaInsumoListView extends StatelessWidget {
  const CategoriaInsumoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoriaInsumoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Categorias de Insumo')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: viewModel.categorias.length,
                itemBuilder: (context, index) {
                  final categoria = viewModel.categorias[index];
                  return Dismissible(
                    key: Key(categoria.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => viewModel.delete(categoria.id!),
                    child: ListTile(
                      title: Text(categoria.descricao),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoriaInsumoFormView(categoria: categoria),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
