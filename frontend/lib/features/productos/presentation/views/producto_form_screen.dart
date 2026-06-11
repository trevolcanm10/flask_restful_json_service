import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../presentation/viewmodels/producto_viewmodel.dart';

/// Pantalla para crear o editar un producto.
/// [isEditing] determina si se está editando un producto existente.
/// [productoId] es requerido si isEditing es true.
class ProductoFormScreen extends StatefulWidget {
  final bool isEditing;
  final int? productoId;

  const ProductoFormScreen({
    super.key,
    required this.isEditing,
    this.productoId,
  });

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.productoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductoForEdit();
      });
    }
  }

  Future<void> _loadProductoForEdit() async {
    final viewModel = context.read<ProductoViewModel>();
    await viewModel.loadProductoById(widget.productoId!);
    final producto = viewModel.selectedProducto;
    if (producto != null) {
      _nombreController.text = producto.nombre;
      _descripcionController.text = producto.descripcion ?? '';
      _categoriaController.text = producto.categoria;
      _precioController.text = producto.precio.toString();
      _stockController.text = producto.stock.toString();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'nombre': _nombreController.text.trim(),
      'descripcion': _descripcionController.text.trim(),
      'categoria': _categoriaController.text.trim(),
      'precio': double.parse(_precioController.text.trim()),
      'stock': int.parse(_stockController.text.trim()),
    };

    final viewModel = context.read<ProductoViewModel>();
    bool success;

    if (widget.isEditing) {
      success = await viewModel.updateProducto(widget.productoId!, data);
    } else {
      success = await viewModel.createProducto(data);
    }

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        SnackbarUtils.showSuccess(
          context,
          widget.isEditing
              ? 'Producto actualizado correctamente'
              : 'Producto creado correctamente',
        );
        // Recargar lista y volver
        await viewModel.loadProductos();
        if (mounted) context.pop();
      } else {
        SnackbarUtils.showError(
          context,
          viewModel.errorMessage ?? 'Error al guardar el producto',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? AppConstants.editarProducto : AppConstants.crearProducto;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: AppConstants.nombreLabel,
                  prefixIcon: Icon(Icons.label_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: AppConstants.descripcionLabel,
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Categoría
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: AppConstants.categoriaLabel,
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La categoría es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Precio
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: AppConstants.precioLabel,
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final precio = double.tryParse(value.trim());
                  if (precio == null || precio < 0) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Stock
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: AppConstants.stockLabel,
                  prefixIcon: Icon(Icons.inventory_outlined),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSubmit(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El stock es obligatorio';
                  }
                  final stock = int.tryParse(value.trim());
                  if (stock == null || stock < 0) {
                    return 'Ingrese un stock válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón de guardar
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(AppConstants.guardarButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}