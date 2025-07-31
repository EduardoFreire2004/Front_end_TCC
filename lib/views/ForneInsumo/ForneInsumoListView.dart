import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewModel.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoFormView.dart';
import 'package:provider/provider.dart';

class FornecedorInsumoListView extends StatefulWidget {
  @override
  State<FornecedorInsumoListView> createState() => _FornecedorInsumoListViewState();
}

class _FornecedorInsumoListViewState extends State<FornecedorInsumoListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'nome'; // Valor padrão

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForneInsumoViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fornecedores de Insumos'),
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
              child: viewModel.isLoading && viewModel.forneInsumo.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.forneInsumo.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Nenhum fornecedor de insumo cadastrado ainda.\nToque no botão "+" para adicionar.'
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
                          itemCount: viewModel.forneInsumo.length,
                          itemBuilder: (context, index) {
                            final fornecedor = viewModel.forneInsumo[index];
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
                                        // Avatar com a primeira letra do nome
                                        CircleAvatar(
                                          backgroundColor: isDark ? Colors.green[800] : Colors.green[100],
                                          child: Text(
                                            fornecedor.nome?.isNotEmpty == true 
                                                ? fornecedor.nome![0].toUpperCase()
                                                : '?',
                                            style: TextStyle(
                                              color: isDark ? Colors.white : Colors.green[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
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
                                              builder: (_) => FornecedorInsumoFormView(fornecedor: fornecedor),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FornecedorInsumoFormView()),
        ),
        tooltip: 'Adicionar Fornecedor',
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}