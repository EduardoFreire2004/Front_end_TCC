import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/TipoAgrotoxicoViewmodel.dart';
import 'TipoAgrotoxicoFormView.dart';

class TipoAgrotoxicoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TipoAgrotoxicoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tipos de Agrotóxicos')),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: viewModel.tipos.length,
                itemBuilder: (context, index) {
                  final tipo = viewModel.tipos[index];
                  return Dismissible(
                    key: Key(tipo.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 16), child: Icon(Icons.delete, color: Colors.white)),
                    onDismissed: (_) => viewModel.deleteTipo(tipo.id!),
                    child: ListTile(
                      title: Text(tipo.descricao),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TipoAgrotoxicoFormView(tipo: tipo)),
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
          MaterialPageRoute(builder: (_) => TipoAgrotoxicoFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
