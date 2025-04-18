import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/agrotoxicoViewmodel.dart';
import 'pages/AgrotoxicoPage.dart'; // Sua página de cadastro

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgrotoxicoViewModel()),
        // aqui você pode adicionar mais ViewModels se tiver
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Agrotóxicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: AgrotoxicoView(), // <- Aqui define a página que abre primeiro
      routes: {'/Agrotoxico': (_) => AgrotoxicoView()},
    );
  }
}
