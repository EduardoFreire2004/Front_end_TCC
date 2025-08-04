import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/AplicacaoInsumo/AplicacaoInsumoListView.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/ForneAgrotoxico/FornecedorAgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FonecedorSementeListView.dart';
import 'package:flutter_fgl_1/views/Insumo/InsumoListView.dart';
import 'package:flutter_fgl_1/views/Plantio/PlantioListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';

class LavouraDetalhesView extends StatelessWidget {
  final LavouraModel lavoura;

  const LavouraDetalhesView({super.key, required this.lavoura});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(title: Text('Lavoura: ${lavoura.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lavoura.nome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Área: ${lavoura.area} ha',
              style: TextStyle(fontSize: 16, color: subtitleColor),
            ),
            const Divider(height: 24, thickness: 1),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  buildCard(
                    'Aplicações de Agrotóxicos',
                    Icons.local_florist,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AplicacaoListView(lavouraId: lavoura.id!),
                      ),
                    ),
                  ),
                  buildCard(
                    'Plantios',
                    Icons.agriculture,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlantioListView(lavouraId: lavoura.id!),
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
                            (_) =>
                                AplicacaoInsumoListView(lavouraId: lavoura.id!),
                      ),
                    ),
                  ),
                  buildCard(
                    'Sementes',
                    Icons.spa,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SementeListView(),
                      ),
                    ),
                  ),
                  buildCard(
                    'Colheitas',
                    Icons.grass,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ColheitaListView(lavouraId: lavoura.id!,)),
                    ),
                  ),
                  buildCard(
                    'Agrotóxicos',
                    Icons.science,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AgrotoxicoListView(),
                      ),
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
                  buildCard('Fornecedores', Icons.store, () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder:
                          (context) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Selecione o tipo de fornecedor',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.bug_report,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Fornecedor Agrotóxico'),
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  FornecedorAgrotoxicoListView(),
                                        ),
                                      ),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.inventory,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Fornecedor Insumo'),
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => FornecedorInsumoListView(),
                                        ),
                                      ),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.grass,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Fornecedor Semente'),
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  FornecedorSementeListView(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
