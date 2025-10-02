import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/AplicacaoInsumo/AplicacaoInsumoListView.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/Insumo/InsumoListView.dart';
import 'package:flutter_fgl_1/views/Plantio/PlantioListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';
import 'package:flutter_fgl_1/views/MovimentacaoEstoque/MovimentacaoEstoqueListView.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatoriosMainScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioCompletoLavouraScreen.dart';
import 'package:flutter_fgl_1/views/Custos/CustosView.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraFormView.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:provider/provider.dart';

class LavouraDetalhesView extends StatefulWidget {
  final LavouraModel lavoura;

  const LavouraDetalhesView({super.key, required this.lavoura});

  @override
  State<LavouraDetalhesView> createState() => _LavouraDetalhesViewState();
}

class _LavouraDetalhesViewState extends State<LavouraDetalhesView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _editarLavoura() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LavouraFormView(lavoura: widget.lavoura),
      ),
    );

    if (result == true) {

      setState(() {});
    }
  }

  void _excluirLavoura() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text(
              'Tem certeza que deseja excluir a lavoura "${widget.lavoura.nome}"?\n\n'
              'Esta ação não pode ser desfeita e todos os dados relacionados '
              '(plantios, aplicações, colheitas, etc.) serão perdidos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmacao == true) {
      try {
        final viewModel = Provider.of<LavouraViewModel>(context, listen: false);
        final sucesso = await viewModel.delete(widget.lavoura.id!);

        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lavoura "${widget.lavoura.nome}" excluída com sucesso',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Volta para a lista
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao excluir lavoura: ${viewModel.errorMessage}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir lavoura: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLavouraSection() {
    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color cardColor = Colors.green.shade50;
    final Color subtitleColor = Colors.grey[700]!;

    Widget buildCard(String title, IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          color: cardColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: primaryColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            widget.lavoura.nome,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Área: ${widget.lavoura.area} ha',
            style: TextStyle(fontSize: 16, color: subtitleColor),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Localização',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Latitude: ${widget.lavoura.latitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                      Text(
                        'Longitude: ${widget.lavoura.longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24, thickness: 1),

          Text(
            'Operações da Lavoura',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              buildCard(
                'Plantios',
                Icons.agriculture,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PlantioListView(lavouraId: widget.lavoura.id!),
                  ),
                ),
              ),
              buildCard(
                'Aplicações de Agrotóxicos',
                Icons.local_florist,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AplicacaoListView(lavouraId: widget.lavoura.id!),
                  ),
                ),
              ),
              buildCard(
                'Aplicações de Insumos',
                Icons.local_florist,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AplicacaoInsumoListView(
                          lavouraId: widget.lavoura.id!,
                        ),
                  ),
                ),
              ),
              buildCard(
                'Custos',
                Icons.attach_money,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CustosView(
                          lavouraId: widget.lavoura.id!,
                          nomeLavoura: widget.lavoura.nome,
                        ),
                  ),
                ),
              ),
              buildCard(
                'Colheitas',
                Icons.grass,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ColheitaListView(lavouraId: widget.lavoura.id!),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RelatoriosMainScreen(
                            lavouraId: widget.lavoura.id!,
                            nomeLavoura: widget.lavoura.nome,
                          ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.green[100],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.green[600]!, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.assessment,
                              size: 32,
                              color: Colors.green[700],
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Relatórios PDF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Novo Sistema',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RelatorioCompletoLavouraScreen(
                            lavouraId: widget.lavoura.id!,
                            nomeLavoura: widget.lavoura.nome,
                          ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.blue[100],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.blue[600]!, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.agriculture,
                              size: 32,
                              color: Colors.blue[700],
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Relatório Completo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dados Consolidados',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          _buildNextSectionHint(),
        ],
      ),
    );
  }

  Widget _buildEstoqueSection() {
    final Color primaryColor = Colors.green[700]!;
    final Color titleColor = Colors.green[800]!;
    final Color cardColor = Colors.green.shade50;
    final Color subtitleColor = Colors.grey[700]!;

    Widget buildCard(String title, IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          color: cardColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: primaryColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            widget.lavoura.nome,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Área: ${widget.lavoura.area} ha',
            style: TextStyle(fontSize: 16, color: subtitleColor),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Localização',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Latitude: ${widget.lavoura.latitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                      Text(
                        'Longitude: ${widget.lavoura.longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24, thickness: 1),

          Text(
            'Gestão de Estoque',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              buildCard(
                'Agrotóxicos',
                Icons.science,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AgrotoxicoListView()),
                ),
              ),
              buildCard(
                'Sementes',
                Icons.spa,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SementeListView()),
                ),
              ),
              buildCard(
                'Insumos',
                Icons.inventory_2,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InsumoListView()),
                ),
              ),
              buildCard(
                'Fornecedores',
                Icons.inventory_2,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FornecedoresListView()),
                ),
              ),
              buildCard(
                'Movimentações de Estoque',
                Icons.inventory,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => MovimentacaoEstoqueListView(
                          lavouraId: widget.lavoura.id!,
                        ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          _buildPreviousSectionHint(),
        ],
      ),
    );
  }

  Widget _buildNextSectionHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.swipe_left, color: Colors.orange[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deslize para a esquerda',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acesse a gestão de estoque desta lavoura',
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.orange[600], size: 16),
        ],
      ),
    );
  }

  Widget _buildPreviousSectionHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.blue[600], size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deslize para a direita',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Volte para as operações da lavoura',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.swipe_right, color: Colors.blue[600], size: 24),
        ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage == 0
              ? 'Lavoura: ${widget.lavoura.nome}'
              : 'Estoque: ${widget.lavoura.nome}',
        ),
        actions: [
          IconButton(
            onPressed: _editarLavoura,
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Lavoura',
          ),
          IconButton(
            onPressed: _excluirLavoura,
            icon: const Icon(Icons.delete),
            tooltip: 'Excluir Lavoura',
            color: Colors.red,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildPageIndicator(),
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
        children: [_buildLavouraSection(), _buildEstoqueSection()],
      ),
    );
  }
}

