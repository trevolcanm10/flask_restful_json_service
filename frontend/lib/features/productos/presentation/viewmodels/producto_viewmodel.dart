import 'package:flutter/material.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../../domain/usecases/get_productos_usecase.dart';
import '../../domain/usecases/search_productos_usecase.dart';
import '../../domain/usecases/create_producto_usecase.dart';
import '../../domain/usecases/update_producto_usecase.dart';
import '../../domain/usecases/delete_producto_usecase.dart';
import '../../data/repositories/producto_repository_impl.dart';

/// ViewModel de productos. Gestiona el estado del listado,
/// detalle, creación, edición y eliminación de productos.
class ProductoViewModel extends ChangeNotifier {
  final ProductoRepository _repository;
  late final GetProductosUseCase _getProductosUseCase;
  late final SearchProductosUseCase _searchProductosUseCase;
  late final CreateProductoUseCase _createProductoUseCase;
  late final UpdateProductoUseCase _updateProductoUseCase;
  late final DeleteProductoUseCase _deleteProductoUseCase;

  List<Producto> _productos = [];
  List<Producto> _filteredProductos = [];
  Producto? _selectedProducto;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';

  ProductoViewModel()
      : _repository = ProductoRepositoryImpl() {
    _getProductosUseCase = GetProductosUseCase(_repository);
    _searchProductosUseCase = SearchProductosUseCase(_repository);
    _createProductoUseCase = CreateProductoUseCase(_repository);
    _updateProductoUseCase = UpdateProductoUseCase(_repository);
    _deleteProductoUseCase = DeleteProductoUseCase(_repository);
  }

  List<Producto> get productos =>
      _isSearching ? _filteredProductos : _productos;
  Producto? get selectedProducto => _selectedProducto;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Carga todos los productos desde la API.
  Future<void> loadProductos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productos = await _getProductosUseCase.execute();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar productos';
      notifyListeners();
    }
  }

  /// Busca productos por texto.
  Future<void> searchProductos(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _isSearching = false;
      _filteredProductos = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _isLoading = true;
    notifyListeners();

    try {
      _filteredProductos = await _searchProductosUseCase.execute(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carga un producto por su ID.
  Future<void> loadProductoById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProducto = await _repository.getProductoById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar el producto';
      notifyListeners();
    }
  }

  /// Crea un nuevo producto.
  Future<bool> createProducto(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _createProductoUseCase.execute(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al crear el producto';
      notifyListeners();
      return false;
    }
  }

  /// Actualiza un producto existente.
  Future<bool> updateProducto(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateProductoUseCase.execute(id, data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar el producto';
      notifyListeners();
      return false;
    }
  }

  /// Elimina un producto por su ID.
  Future<bool> deleteProducto(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _deleteProductoUseCase.execute(id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al eliminar el producto';
      notifyListeners();
      return false;
    }
  }

  /// Limpia la selección actual.
  void clearSelection() {
    _selectedProducto = null;
  }

  /// Limpia los errores.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}