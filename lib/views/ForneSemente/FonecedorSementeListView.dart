import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewModel.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FornecedorSementeFormView.dart';
import 'package:provider/provider.dart';

class FornecedorSementeListView extends StatefulWidget {
  @override
  State<FornecedorSementeListView> createState() =>
      _FornecedorSementeListViewState();
}

class _FornecedorSementeListViewState extends State<FornecedorSementeListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'nome'; 

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForneSementeViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );
        
    final Color errorColor = Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fornecedores de Sementes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSearchType,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.iconTheme.color,
                    ),
                    style: theme.textTheme.bodyMedium,
                    items: const [
                      DropdownMenuItem(value: 'cnpj', child: Text('CNPJ')),
                      DropdownMenuItem(value: 'nome', child: Text('Nome')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSearchType = newValue!;
                      });
                      if (_searchController.text.isNotEmpty) {
                        viewModel.fetchByParametro(
                          _selectedSearchType,
                          _searchController.text,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        viewModel.fetch();
                      } else {
                        viewModel.fetchByParametro(_selectedSearchType, value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: Column(
          children: [
            Expanded(
              child:
                  viewModel.isLoading && viewModel.forneSemente.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.forneSemente.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'Nenhum fornecedor de semente cadastrado ainda.\nToque no botão "+" para adicionar.'
                                : 'Nenhum fornecedor encontrado para "${_searchController.text}".',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: viewModel.forneSemente.length,
                        itemBuilder: (context, index) {
                          final fornecedor = viewModel.forneSemente[index];
                          return Dismissible(
                            key: Key(fornecedor.id.toString()),
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                        'Deseja realmente excluir este Fornecedor?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (fornecedor.id != null) {
                                              await viewModel.delete(
                                                fornecedor.id!,
                                              
                                              );
                                              Navigator.of(context).pop(true);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Fornecedor excluído.',
                                                        ),
                                                        backgroundColor:
                                                            errorColor,
                                                      ),
                                                    );
                                                  });
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
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            isDark
                                                ? Colors.green[800]
                                                : Colors.green[100],
                                        child: Text(
                                          fornecedor.nome?.isNotEmpty == true
                                              ? fornecedor.nome![0]
                                                  .toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : Colors.green[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              fornecedor.nome ??
                                                  'Nome não disponível',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        isDark
                                                            ? Colors.green[200]
                                                            : Colors.green[800],
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8.0),
                                            if (fornecedor.cnpj?.isNotEmpty ??
                                                false)
                                              Text(
                                                'CNPJ: ${fornecedor.cnpj}',
                                                style: subtitleStyle,
                                              ),
                                            const SizedBox(height: 8.0),
                                            if (fornecedor
                                                    .telefone
                                                    ?.isNotEmpty ??
                                                false)
                                              Text(
                                                'TELEFONE: ${fornecedor.telefone}',
                                                style: subtitleStyle,
                                              ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color:
                                              isDark
                                                  ? Colors.blue[200]
                                                  : Colors.blueGrey[600],
                                        ),
                                        tooltip: 'Editar Fornecedor',
                                        onPressed:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        FornecedorSementeFormView(
                                                          fornecedor:
                                                              fornecedor,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FornecedorSementeFormView()),
            ),
        tooltip: 'Adicionar Fornecedor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
