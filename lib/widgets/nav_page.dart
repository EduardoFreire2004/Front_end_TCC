import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ThemaProviderViewModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/ForneAgrotoxico/FornecedorAgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FonecedorSementeListView.dart';
import 'package:flutter_fgl_1/views/Insumo/InsumoListView.dart';
import 'package:flutter_fgl_1/views/Semente/SementeListView.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Colors.green[600]!;
    final Color headerTextColor = Colors.white;
    final Color iconItemColor = Colors.green[700]!;
    final Color textItemColor = Colors.green[800]!;
    final FontWeight textItemWeight = FontWeight.w500;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: headerColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 32, color: Colors.green[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Eduardo Freire',
                  style: TextStyle(
                    color: headerTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.store, color: iconItemColor),
            title: Text(
              'Fornecedores',
              style: TextStyle(
                color: textItemColor,
                fontWeight: textItemWeight,
              ),
            ),
            children: [
              _buildSubNavItem(
                context,
                'Fornecedor Agrotóxicos',
                FornecedorAgrotoxicoListView(),
              ),
              _buildSubNavItem(
                context,
                'Fornecedor Sementes',
                FornecedorSementeListView(),
              ),
              _buildSubNavItem(
                context,
                'Fornecedor Insumos',
                FornecedorInsumoListView(),
              ),
            ],
          ),
          _buildNavItem(
            context,
            Icons.bug_report,
            'Agrotóxicos',
            AgrotoxicoListView(),
          ),
          _buildNavItem(
            context,
            Icons.grass,
            'Sementes',
            SementeListView(),
          ),
          _buildNavItem(
            context,
            Icons.science,
            'Insumos',
            InsumoListView(),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: iconItemColor,
            ),
            title: Text(
              isDarkMode ? 'Tema Claro' : 'Tema Escuro',
              style: TextStyle(
                color: textItemColor,
                fontWeight: textItemWeight,
              ),
            ),
            onTap: () {
              themeProvider.toggleTheme();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(
        title,
        style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  ListTile _buildSubNavItem(BuildContext context, String title, Widget page) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: 72),
      title: Text(
        title,
        style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w400),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
