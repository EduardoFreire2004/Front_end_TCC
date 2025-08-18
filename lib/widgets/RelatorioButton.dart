import 'package:flutter/material.dart';

class RelatorioButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const RelatorioButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Gerar Relatório PDF',
    this.icon = Icons.picture_as_pdf,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange[600],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white),
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(padding: const EdgeInsets.all(12)),
      ),
    );
  }
}

