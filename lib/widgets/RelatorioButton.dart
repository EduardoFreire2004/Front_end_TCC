import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:flutter_fgl_1/views/RelatoriosScreen.dart';

class RelatorioButton extends StatelessWidget {
  final String? texto;
  final IconData? icone;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const RelatorioButton({
    Key? key,
    this.texto,
    this.icone,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RelatoriosScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        icon: Icon(icone ?? Icons.assessment, size: 20),
        label: Text(
          texto ?? 'Relatórios',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// Widget específico para o card de relatórios (como mostrado nas imagens)
class RelatorioCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color? corIcone;

  const RelatorioCard({
    Key? key,
    required this.titulo,
    required this.descricao,
    required this.icone,
    this.corIcone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RelatoriosScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (corIcone ?? AppColors.primaryGreen).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icone,
                  color: corIcone ?? AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para exibir na tela principal ou dashboard
class RelatorioSection extends StatelessWidget {
  const RelatorioSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Relatórios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        RelatorioCard(
          titulo: 'Relatórios em PDF',
          descricao: 'Gere relatórios detalhados de sua lavoura',
          icone: Icons.assessment,
          corIcone: AppColors.primaryGreen,
        ),
      ],
    );
  }
}
