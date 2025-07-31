import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/ForneAgrotoxicoViewModel.dart';
import 'FornecedorAgrotoxicoFormView.dart';

class FornecedorAgrotoxicoListView extends StatefulWidget {
  const FornecedorAgrotoxicoListView({super.key});

  @override
  State<FornecedorAgrotoxicoListView> createState() => _FornecedorAgrotoxicoListViewState();
}

class _FornecedorAgrotoxicoListViewState extends State<FornecedorAgrotoxicoListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'nome'; // Valor padrão

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              viewModel.fetch();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        child: Column(
          children: [
            // Campo de busca com seleção de tipo
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Dropdown para selecionar o tipo de busca
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
                      icon: Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
                      style: theme.textTheme.bodyMedium,
                      items: const [
                        DropdownMenuItem(
                          value: 'cnpj',
                          child: Text('CNPJ'),
                        ),
                        DropdownMenuItem(
                          value: 'nome',
                          child: Text('Nome'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSearchType = newValue!;
                        });
                        if (_searchController.text.isNotEmpty) {
                          viewModel.fetchByParametro(_selectedSearchType, _searchController.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Campo de texto para busca
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por ${_selectedSearchType == 'cnpj' ? 'CNPJ' : 'Nome'}',
                        hintText: _selectedSearchType == 'cnpj' 
                            ? 'Digite o CNPJ' 
                            : 'Digite o nome',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  viewModel.fetch();
                                },
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          viewModel.fetch();
                        } else {
                          viewModel.fetchByParametro(_selectedSearchType, value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Lista de resultados
            Expanded(
              child: viewModel.isLoading && viewModel.forneAgrotoxico.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.forneAgrotoxico.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Nenhum fornecedor cadastrado.'
                                  : 'Nenhum fornecedor encontrado para "${_searchController.text}".',
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
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                leading: CircleAvatar(
                                  backgroundColor: isDark ? Colors.green[800] : Colors.green[100],
                                  child: Text(
                                    fornecedor.nome?.substring(0, 1) ?? '?',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.green[800],
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
                                      Text('CNPJ: ${fornecedor.cnpj}', style: subtitleStyle),
                                    if (fornecedor.telefone?.isNotEmpty ?? false)
                                      Text('Telefone: ${fornecedor.telefone}', style: subtitleStyle),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: theme.primaryColor),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FornecedorAgrotoxicoFormView(fornecedor: fornecedor),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Confirmar exclusão'),
                                            content: Text('Deseja realmente excluir ${fornecedor.nome ?? 'este fornecedor'}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (fornecedor.id != null) {
                                                    viewModel.delete(fornecedor.id!);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('${fornecedor.nome} excluído.'),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FornecedorAgrotoxicoFormView(fornecedor: fornecedor),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FornecedorAgrotoxicoFormView()),
        ),
        tooltip: 'Adicionar Fornecedor',
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}