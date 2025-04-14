import 'package:flutter/material.dart';
import '../widgets/nav_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao AgroApp'),
        backgroundColor: Colors.green[700],
      ),
      drawer: const NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 80, color: Colors.green[800]),
            const SizedBox(height: 20),
            const Text(
              'Gerencie suas lavouras com facilidade!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.grass),
              label: const Text("Ver Lavouras"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                // Navegar para a tela de lavouras
                // Navigator.push(...);
              },
            ),
          ],
        ),
      ),
    );
  }
}
