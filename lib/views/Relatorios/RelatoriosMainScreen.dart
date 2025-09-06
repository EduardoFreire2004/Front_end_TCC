import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioAgrotoxicosScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioPlantiosScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioInsumosScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioColheitasScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioEstoqueScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioSementesScreen.dart';
import 'package:flutter_fgl_1/views/Relatorios/RelatorioCustosScreen.dart';

class RelatoriosMainScreen extends StatelessWidget {
  const RelatoriosMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGradientEnd.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Relatórios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assessment,
                          color: AppColors.primaryGreen,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Relatórios Disponíveis',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selecione o tipo de relatório que deseja gerar',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de relatórios
            _buildRelatorioCard(
              context,
              icon: Icons.eco,
              title: 'Relatório de Plantios',
              subtitle: 'Visualize informações sobre plantios realizados',
              color: Colors.green,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioPlantiosScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.pest_control,
              title: 'Relatório de Agrotóxicos',
              subtitle: 'Acompanhe aplicações de agrotóxicos',
              color: Colors.red,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioAgrotoxicosScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.science,
              title: 'Relatório de Insumos',
              subtitle: 'Controle de aplicações de insumos',
              color: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioInsumosScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.grass,
              title: 'Relatório de Colheitas',
              subtitle: 'Acompanhe resultados das colheitas',
              color: Colors.orange,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioColheitasScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.inventory,
              title: 'Relatório de Estoque',
              subtitle: 'Controle de movimentação de estoque',
              color: Colors.purple,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioEstoqueScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.local_florist,
              title: 'Relatório de Sementes',
              subtitle: 'Controle de sementes utilizadas',
              color: Colors.teal,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioSementesScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),

            _buildRelatorioCard(
              context,
              icon: Icons.attach_money,
              title: 'Relatório de Custos',
              subtitle: 'Análise de custos operacionais',
              color: Colors.indigo,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelatorioCustosScreen(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatorioCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
