import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../presentation/viewmodels/producto_viewmodel.dart';
import '../../presentation/widgets/delete_dialog.dart';

/// Pantalla de detalle de un producto.
/// Muestra información completa y ofrece editar/eliminar.
class ProductoDetailScreen extends StatefulWidget {
  final int productoId;

  const ProductoDetailScreen({
    super.key,
    required this.productoId,
  });

  @override
  State<ProductoDetailScreen> createState() => _ProductoDetailScreenState();
}

class _ProductoDetailScreenState extends State<ProductoDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoViewModel>().loadProductoById(widget.productoId);
    });
  }

  Future<void> _deleteProducto() async {
    final viewModel = context.read<ProductoViewModel>();
    final producto = viewModel.selectedProducto;

    if (producto == null) return;

    final confirm = await DeleteDialog.show(
      context,
      productName: producto.nombre,
      onConfirm: () {},
    );

    if (confirm == true && mounted) {
      final success = await viewModel.deleteProducto(widget.productoId);
      if (mounted) {
        if (success) {
          SnackbarUtils.showSuccess(context, AppConstants.productoEliminado);
          context.pop();
        } else {
          SnackbarUtils.showError(
            context,
            viewModel.errorMessage ?? AppConstants.errorCargar,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.detalleProducto),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: AppConstants.editarProducto,
            onPressed: () =>
                context.push('/productos/editar/${widget.productoId}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: AppConstants.eliminarButton,
            onPressed: _deleteProducto,
          ),
        ],
      ),
      body: Consumer<ProductoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final producto = viewModel.selectedProducto;
          if (producto == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64,
                      color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage ?? 'Producto no encontrado',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del producto
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            producto.categoria,
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Información detallada
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información del Producto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.description_outlined,
                          'Descripción',
                          producto.descripcion ?? 'Sin descripción',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.monetization_on_outlined,
                          'Precio',
                          currencyFormat.format(producto.precio),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.inventory_outlined,
                          'Stock',
                          '${producto.stock} unidades',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.circle,
                          'Estado',
                          producto.activo ? 'Activo' : 'Inactivo',
                          valueColor: producto.activo
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}