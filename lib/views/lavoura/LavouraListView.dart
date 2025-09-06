import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraDetalhesView.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraFormView.dart';
import 'package:flutter_fgl_1/config/list_config.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:provider/provider.dart';

class LavouraListView extends StatefulWidget {
  const LavouraListView({super.key});

  @override
  State<LavouraListView> createState() => _LavouraListViewState();
}

class _LavouraListViewState extends State<LavouraListView> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildLavouraSection(LavouraViewModel viewModel) {
    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color subtitleColor = Colors.grey[700]!;
    final Color iconColor = Colors.green[700]!;

    return RefreshIndicator(
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
              : ListConfig.defaultListView(
                padding: const EdgeInsets.all(8.0),
                children: List.generate(viewModel.lavoura.length, (index) {
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
                                  const SizedBox(height: 8.0),
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
                }),
              ),
    );
  }

  Widget _buildEstoqueSection() {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implementar refresh para estoque
      },
      color: AppColors.primaryGreen,
      child: ListConfig.defaultListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildEstoqueCard(
            title: 'Agrotóxicos',
            subtitle: 'Gerenciar estoque de agrotóxicos',
            icon: Icons.pest_control,
            color: Colors.red,
            onTap: () {
              // TODO: Navegar para tela de agrotóxicos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          _buildEstoqueCard(
            title: 'Insumos',
            subtitle: 'Gerenciar estoque de insumos',
            icon: Icons.science,
            color: Colors.blue,
            onTap: () {
              // TODO: Navegar para tela de insumos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          _buildEstoqueCard(
            title: 'Sementes',
            subtitle: 'Gerenciar estoque de sementes',
            icon: Icons.eco,
            color: Colors.green,
            onTap: () {
              // TODO: Navegar para tela de sementes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          _buildEstoqueCard(
            title: 'Movimentações',
            subtitle: 'Histórico de movimentações',
            icon: Icons.swap_horiz,
            color: Colors.orange,
            onTap: () {
              // TODO: Navegar para tela de movimentações
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEstoqueCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                _currentPage == index
                    ? AppColors.primaryGreen
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LavouraViewModel>(context);
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
        title: Text(_currentPage == 0 ? 'Lavouras' : 'Gestão de Estoque'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              if (_currentPage == 0)
                Padding(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildPageIndicator(),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [_buildLavouraSection(viewModel), _buildEstoqueSection()],
      ),
      floatingActionButton:
          _currentPage == 0
              ? FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LavouraFormView(),
                      ),
                    ),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
