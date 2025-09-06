import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacaoInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/CustoViewModel.dart';
import 'package:flutter_fgl_1/services/custo_service.dart';
import 'package:flutter_fgl_1/viewmodels/MovimentacaoEstoqueViewModel.dart';
import 'package:flutter_fgl_1/views/Lavoura/LavouraListView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ThemaProviderViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AuthViewModel.dart';

import 'package:flutter_fgl_1/widgets/nav_page.dart';
import 'package:flutter_fgl_1/views/Auth/LoginView.dart';
import 'package:flutter_fgl_1/config/app_theme.dart';
import 'package:flutter_fgl_1/config/list_config.dart';
import 'package:provider/provider.dart';

// Configuração global para listas
class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Define a física de scroll padrão para todas as listas
    return ListConfig.defaultScrollPhysics;
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Configuração padrão da scrollbar
    return ListConfig.defaultScrollbar(child: child);
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

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
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = TipoAgrotoxicoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = FornecedoresViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = AgrotoxicoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = AplicacaoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),

        ChangeNotifierProvider(
          create: (_) {
            final viewModel = CategoriaInsumoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = InsumoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = SementeViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = PlantioViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = ColheitaViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = LavouraViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = AplicacaoInsumoViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            // CustoViewModel requer um CustoService que precisa de token
            // Será criado dinamicamente quando necessário
            return CustoViewModel(CustoService(token: ''));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final viewModel = MovimentacaoEstoqueViewModel();
            viewModel.fetch();
            return viewModel;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FGL - Gerenciamento de Lavouras',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR'), Locale('en', '')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            scrollBehavior: CustomScrollBehavior(),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isAuthenticated) {
          return const MainScreenScaffold();
        } else {
          return const LoginView();
        }
      },
    );
  }
}

class MainScreenScaffold extends StatelessWidget {
  const MainScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FGL'),
        actions: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authViewModel.logout(),
                tooltip: 'Sair',
              );
            },
          ),
        ],
      ),
      drawer: const NavBar(),
      body: const LavouraListView(),
    );
  }
}
