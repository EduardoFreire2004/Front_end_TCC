import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/CategoriaInsumo/CategoriaInsumoListView.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FonecedorSementeListView.dart';
import 'package:flutter_fgl_1/views/Insumo/insumoListView.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraListView.dart';
import 'package:flutter_fgl_1/views/plantio/PlantioListView.dart';
import 'package:flutter_fgl_1/views/semente/SementeListView.dart';
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
        ChangeNotifierProvider(create: (_) => ForneAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AplicacaoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => ForneInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => CategoriaInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => InsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => ForneSementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => SementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => PlantioViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => ColheitaViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => LavouraViewModel()..fetch()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FGL - Gerenciamento de Lavouras',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: LavouraListView(), 
      ),    
    );
  }
}