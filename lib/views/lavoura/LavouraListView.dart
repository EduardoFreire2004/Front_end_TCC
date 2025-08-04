import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraDetalhesView.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraFormView.dart';
import 'package:provider/provider.dart';

class LavouraListView extends StatefulWidget {
  const LavouraListView({super.key});

  @override
  State<LavouraListView> createState() => _LavouraListViewState();
}

class _LavouraListViewState extends State<LavouraListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LavouraViewModel>(context);

    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;
    final Color errorColor = Colors.redAccent;
    final Color scaffoldBgColor = Colors.grey[50]!;

    if (viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: errorColor,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text('Lavouras'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  viewModel.fetch();
                } else {
                  viewModel.fetchByNome(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetch(),
        color: primaryColor,
        child:
            viewModel.isLoading && viewModel.lavoura.isEmpty
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : viewModel.lavoura.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhuma lavoura cadastrada.\nToque no botão "+" para adicionar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: viewModel.lavoura.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.lavoura[index];
                    return Card(
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
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => LavouraDetalhesView(lavoura: item),
                              ),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: iconColor.withOpacity(0.1),
                                child: Icon(Icons.park, color: iconColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nome,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: titleColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Área: ${item.area} ha',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: subtitleColor),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LavouraFormView()),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
