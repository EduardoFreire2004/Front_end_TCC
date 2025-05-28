import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneAgrotoxicoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewmodel.dart';
import 'package:flutter_fgl_1/views/agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/categoria_insumo/CategoriaInsumoListView.dart';
import 'package:flutter_fgl_1/views/forne_insumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/fornecedor_agrotoxico/FornecedorAgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/insumo/insumoListView.dart';
import 'package:provider/provider.dart';
import 'viewmodels/TipoAgrotoxicoViewmodel.dart';


void main() {
  runApp(const FGLApp());
}

class FGLApp extends StatelessWidget {
  const FGLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TipoAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => FornecedorAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AplicacaoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => FornecedorInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => CategoriaInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => InsumoViewModel()..fetch()),

        // Você pode adicionar outros ViewModels aqui, como:
        // ChangeNotifierProvider(create: (_) => FornecedorAgrotoxicoViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FGL - Gerenciamento de Lavouras',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: InsumoListView(), // Tela inicial
      ),    
    );
  }
}
