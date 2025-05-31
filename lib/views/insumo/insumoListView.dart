import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewmodel.dart';
import 'package:flutter_fgl_1/views/Insumo/insumoFormView.dart';
import 'package:provider/provider.dart';

class InsumoListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InsumoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Insumos')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: viewModel.insumo.length,
                itemBuilder: (context, index) {
                  final insumo = viewModel.insumo[index];
                  return Dismissible(
                    key: Key(insumo.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => viewModel.delete(insumo.id!),
                    child: ListTile(
                      title: Text(insumo.nome),
                      subtitle: Text('Qtd: ${insumo.qtde} ${insumo.unidade_Medida}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InsumoFormView(insumo: insumo),
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
          MaterialPageRoute(builder: (_) => InsumoFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
