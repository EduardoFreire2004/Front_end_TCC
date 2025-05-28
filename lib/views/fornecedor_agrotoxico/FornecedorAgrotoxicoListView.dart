import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/ForneAgrotoxicoViewmodel.dart';
import 'FornecedorAgrotoxicoFormView.dart';

class FornecedorAgrotoxicoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FornecedorAgrotoxicoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Fornecedores de Agrotóxicos')),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: viewModel.fornecedores.length,
                itemBuilder: (context, index) {
                  final fornecedor = viewModel.fornecedores[index];
                  return Dismissible(
                    key: Key(fornecedor.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => viewModel.deleteFornecedor(fornecedor.id!),
                    child: ListTile(
                      title: Text(fornecedor.nome),
                      subtitle: Text('CNPJ: ${fornecedor.cnpj}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FornecedorAgrotoxicoFormView(fornecedor: fornecedor),
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
          MaterialPageRoute(builder: (_) => FornecedorAgrotoxicoFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
