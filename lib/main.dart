import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneAgrotoxicoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewmodel.dart';
import 'package:flutter_fgl_1/views/agrotoxico/AgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/categoria_insumo/CategoriaInsumoListView.dart';
import 'package:flutter_fgl_1/views/colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/forne_insumo/ForneInsumoListView.dart';
import 'package:flutter_fgl_1/views/forne_semente/FonecedorSementeListView.dart';
import 'package:flutter_fgl_1/views/fornecedor_agrotoxico/FornecedorAgrotoxicoListView.dart';
import 'package:flutter_fgl_1/views/insumo/insumoListView.dart';
import 'package:flutter_fgl_1/views/lavoura/LavouraListView.dart';
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
        ChangeNotifierProvider(create: (_) => FornecedorAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AplicacaoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => FornecedorInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => CategoriaInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => InsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => FornecedorSementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => SementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => PlantioViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => ColheitaViewmodel()..fetch()),
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