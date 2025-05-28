import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[600],
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              // Navegar para a página de configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Conta'),
            onTap: () {
              // Navegar para a página de conta
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Suporte'),
            onTap: () {
              // Navegar para a página de suporte
            },
          ),
        ],
      ),
    );
  }
}
