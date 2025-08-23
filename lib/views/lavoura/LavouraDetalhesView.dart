import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/AplicacaoInsumo/AplicacaoInsumoListView.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
import 'package:flutter_fgl_1/views/Insumo/InsumoListView.dart';
import 'package:flutter_fgl_1/views/Plantio/PlantioListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';
import 'package:flutter_fgl_1/views/MovimentacaoEstoque/MovimentacaoEstoqueListView.dart';
import 'package:flutter_fgl_1/views/Custos/CustosListView.dart';

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
                      MaterialPageRoute(
                        builder:
                            (_) => ColheitaListView(lavouraId: lavoura.id!),
                      ),
                    ),
                  ),
                  buildCard(
                    'Custos',
                    Icons.attach_money,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustosListView(lavouraId: lavoura.id!),
                      ),
                    ),
                  ),
                  buildCard(
                    'Movimetações de Estoque',
                    Icons.inventory,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MovimentacaoEstoqueListView(
                              lavouraId: lavoura.id!,
                            ),
                      ),
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
                  buildCard(
                    'Fornecedores',
                    Icons.inventory_2,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FornecedoresListView()),
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
