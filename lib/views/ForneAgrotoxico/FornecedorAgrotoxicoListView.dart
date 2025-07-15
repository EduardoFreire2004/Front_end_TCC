import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/ForneAgrotoxicoViewModel.dart';
import 'FornecedorAgrotoxicoFormView.dart';

class FornecedorAgrotoxicoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForneAgrotoxicoViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fornecedores de Agrotóxicos'),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: viewModel.isLoading && viewModel.forneAgrotoxico.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : viewModel.forneAgrotoxico.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhum fornecedor de agrotóxico cadastrado ainda.\nToque no botão "+" para adicionar.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: viewModel.forneAgrotoxico.length,
                    itemBuilder: (context, index) {
                      final fornecedor = viewModel.forneAgrotoxico[index];
                      return Dismissible(
                        key: Key(fornecedor.id.toString()),
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
                          if (fornecedor.id != null) {
                            viewModel.delete(fornecedor.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${fornecedor.nome} excluído.'),
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
                                          fornecedor.nome ?? 'Nome não disponível',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.green[200] : Colors.green[800],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8.0),
                                        if (fornecedor.cnpj?.isNotEmpty ?? false)
                                          Text('CNPJ: ${fornecedor.cnpj}', style: subtitleStyle),
                                        const SizedBox(height: 8.0),
                                        if (fornecedor.telefone?.isNotEmpty ?? false)
                                          Text('TELEFONE: ${fornecedor.telefone}', style: subtitleStyle),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: isDark ? Colors.blue[200] : Colors.blueGrey[600]),
                                    tooltip: 'Editar Fornecedor',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FornecedorAgrotoxicoFormView(fornecedor: fornecedor),
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
          MaterialPageRoute(builder: (_) => FornecedorAgrotoxicoFormView()),
        ),
        tooltip: 'Adicionar Fornecedor',
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
