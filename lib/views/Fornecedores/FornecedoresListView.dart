import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/FornecedoresViewmodel.dart';
import 'FornecedoresFormView.dart';

class FornecedoresListView extends StatefulWidget {
  const FornecedoresListView({super.key});

  @override
  State<FornecedoresListView> createState() =>
      _FornecedorAgrotoxicoListViewState();
}

class _FornecedorAgrotoxicoListViewState extends State<FornecedoresListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'nome'; // Valor padrão

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FornecedoresViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fornecedores'),
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
                  viewModel.isLoading && viewModel.fornecedores.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.fornecedores.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'Nenhum fornecedor cadastrado.'
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
                        itemCount: viewModel.fornecedores.length,
                        itemBuilder: (context, index) {
                          final fornecedor = viewModel.fornecedores[index];
                          return Dismissible(
                            key: Key(fornecedor.id.toString()),
                            direction: DismissDirection.endToStart,
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
                            confirmDismiss: (_) async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: Text(
                                        'Deseja realmente excluir ${fornecedor.nome ?? 'este fornecedor'}?',
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
                                                            Colors.redAccent,
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
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      isDark
                                          ? Colors.green[800]
                                          : Colors.green[100],
                                  child: Text(
                                    fornecedor.nome?.substring(0, 1) ?? '?',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white
                                              : Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  fornecedor.nome ?? 'Nome não disponível',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (fornecedor.cnpj?.isNotEmpty ?? false)
                                      Text(
                                        'CNPJ: ${fornecedor.cnpj}',
                                        style: subtitleStyle,
                                      ),
                                    if (fornecedor.telefone?.isNotEmpty ??
                                        false)
                                      Text(
                                        'Telefone: ${fornecedor.telefone}',
                                        style: subtitleStyle,
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: theme.primaryColor,
                                  ),
                                  onPressed:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => FornecedoresFormView(
                                                fornecedor: fornecedor,
                                              ),
                                        ),
                                      ),
                                ),
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => FornecedoresFormView(
                                              fornecedor: fornecedor,
                                            ),
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
              MaterialPageRoute(builder: (_) => const FornecedoresFormView()),
            ),
        tooltip: 'Adicionar Fornecedor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
