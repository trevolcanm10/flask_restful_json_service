import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../presentation/viewmodels/producto_viewmodel.dart';
import '../../presentation/widgets/producto_card.dart';
import '../../presentation/widgets/search_bar_widget.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';

/// Pantalla principal que lista todos los productos.
/// Incluye búsqueda, pull-to-refresh y FAB para crear.
class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  State<ProductoListScreen> createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoViewModel>().loadProductos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    await context.read<ProductoViewModel>().loadProductos();
  }

  void _onSearchChanged(String query) {
    context.read<ProductoViewModel>().searchProductos(query);
  }

  void _onSearchClear() {
    _searchController.clear();
    context.read<ProductoViewModel>().searchProductos('');
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.productosTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppConstants.cerrarSesion,
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: _onSearchClear,
          ),
          // Listado de productos
          Expanded(
            child: Consumer<ProductoViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading && viewModel.productos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null &&
                    viewModel.productos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _onRefresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.productos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          AppConstants.sinResultados,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppTheme.primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: viewModel.productos.length,
                    itemBuilder: (context, index) {
                      final producto = viewModel.productos[index];
                      return ProductoCard(
                        producto: producto,
                        onTap: () {
                          context.push('/productos/${producto.id}');
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/productos/crear'),
        tooltip: AppConstants.crearProducto,
        child: const Icon(Icons.add),
      ),
    );
  }
}