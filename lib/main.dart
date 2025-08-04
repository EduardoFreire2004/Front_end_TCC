import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacaoInsumoViewModel.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraListView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ThemaProviderViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';

import 'package:flutter_fgl_1/widgets/nav_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const FGLApp());
}

class FGLApp extends StatelessWidget {
  const FGLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TipoAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider( create: (_) => ForneAgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AgrotoxicoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AplicacaoViewModel()),
        ChangeNotifierProvider(create: (_) => ForneInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => CategoriaInsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => InsumoViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => ForneSementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => SementeViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => PlantioViewModel()),
        ChangeNotifierProvider(create: (_) => ColheitaViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => LavouraViewModel()..fetch()),
        ChangeNotifierProvider(create: (_) => AplicacaoInsumoViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FGL - Gerenciamento de Lavouras',
            theme: ThemeData(
              primarySwatch: Colors.green,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR'), Locale('en', '')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainScreenScaffold(),
          );
        },
      ),
    );
  }
}

class MainScreenScaffold extends StatelessWidget {
  const MainScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FGL')),
      drawer: const NavBar(),
      body: const LavouraListView(),
    );
  }
}
