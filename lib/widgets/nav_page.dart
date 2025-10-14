import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ThemaProviderViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AuthViewModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresListView.dart';
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
            child: Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                final usuario = authViewModel.usuario;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      usuario?.nome ?? 'Usuário',
                      style: TextStyle(
                        color: headerTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (usuario?.email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        usuario!.email,
                        style: TextStyle(
                          color: headerTextColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          _buildNavItem(
            context,
            Icons.inventory_2,
            'Fornecedores',
            FornecedoresListView(),
          ),
          _buildNavItem(
            context,
            Icons.science,
            'Agrotóxicos',
            AgrotoxicoListView(),
          ),
          _buildNavItem(context, Icons.grass, 'Sementes', SementeListView()),
          _buildNavItem(context, Icons.science, 'Insumos', InsumoListView()),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[600]),
            title: Text(
              'Sair',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: textItemWeight,
              ),
            ),
            onTap: () {
              context.read<AuthViewModel>().logout();
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
}

