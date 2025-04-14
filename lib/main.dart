import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/ColheitaViewmodel.dart';
import 'pages/ColheitaPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ColheitaViewmodel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gerenciador de Colheitas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const ColheitaPage(),
      ),
    );
  }
}
