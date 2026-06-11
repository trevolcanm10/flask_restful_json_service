import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/dio_client.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/productos/presentation/viewmodels/producto_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthViewModel _authViewModel;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authViewModel = AuthViewModel();

    // Configurar el callback de sesión expirada en DioClient
    DioClient.instance.onUnauthorized = () {
      _authViewModel.logout();
    };

    _appRouter = AppRouter(
      isAuthenticated: () => _authViewModel.isAuthenticated,
      onUnauthorized: () {
        _authViewModel.logout();
      },
      authNotifier: _authViewModel,
    );
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(
          value: _authViewModel,
        ),
        ChangeNotifierProvider<ProductoViewModel>(
          create: (_) => ProductoViewModel(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Gestión de Productos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}