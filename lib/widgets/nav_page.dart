import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ThemaProviderViewModel.dart';
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
            child: Text(
              'Menu',
              style: TextStyle(color: headerTextColor, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: iconItemColor),
            title: Text(
              'Configurações',
              style: TextStyle(
                color: textItemColor,
                fontWeight: textItemWeight,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: iconItemColor),
            title: Text(
              'Conta',
              style: TextStyle(
                color: textItemColor,
                fontWeight: textItemWeight,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: iconItemColor),
            title: Text(
              'Suporte',
              style: TextStyle(
                color: textItemColor,
                fontWeight: textItemWeight,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
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
}
