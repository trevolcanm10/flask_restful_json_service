import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/productos/presentation/views/producto_list_screen.dart';
import '../../features/productos/presentation/views/producto_detail_screen.dart';
import '../../features/productos/presentation/views/producto_form_screen.dart';

/// Configuración del enrutador de la aplicación usando GoRouter.
/// Implementa redirección automática basada en autenticación.
/// Usa [refreshListenable] para re-evaluar el redirect cuando cambia
/// el estado de autenticación.
class AppRouter {
  final bool Function() isAuthenticated;
  final VoidCallback onUnauthorized;
  final ChangeNotifier authNotifier;

  AppRouter({
    required this.isAuthenticated,
    required this.onUnauthorized,
    required this.authNotifier,
  });

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier, // Re-evalúa redirect cuando auth cambia
    redirect: (context, state) {
      final loggedIn = isAuthenticated();
      final isLoginRoute = state.matchedLocation == '/login';

      if (!loggedIn && !isLoginRoute) return '/login';
      if (loggedIn && isLoginRoute) return '/productos';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/productos',
        name: 'productos',
        builder: (context, state) => const ProductoListScreen(),
      ),
      GoRoute(
        path: '/productos/crear',
        name: 'crearProducto',
        builder: (context, state) => const ProductoFormScreen(isEditing: false),
      ),
      GoRoute(
        path: '/productos/editar/:id',
        name: 'editarProducto',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductoFormScreen(isEditing: true, productoId: id);
        },
      ),
      GoRoute(
        path: '/productos/:id',
        name: 'detalleProducto',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductoDetailScreen(productoId: id);
        },
      ),
    ],
  );
}