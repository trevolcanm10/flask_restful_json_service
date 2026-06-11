import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_remote_datasource.dart';

/// Implementación del repositorio de productos.
/// Convierte modelos a entidades del dominio.
class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoRemoteDataSource _dataSource;

  ProductoRepositoryImpl() : _dataSource = ProductoRemoteDataSource();

  @override
  Future<List<Producto>> getProductos() async {
    final models = await _dataSource.getProductos();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Producto>> searchProductos(String query) async {
    final models = await _dataSource.searchProductos(query);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Producto> getProductoById(int id) async {
    final model = await _dataSource.getProductoById(id);
    return model.toEntity();
  }

  @override
  Future<Producto> createProducto(Map<String, dynamic> data) async {
    final model = await _dataSource.createProducto(data);
    return model.toEntity();
  }

  @override
  Future<Producto> updateProducto(int id, Map<String, dynamic> data) async {
    final model = await _dataSource.updateProducto(id, data);
    return model.toEntity();
  }

  @override
  Future<void> deleteProducto(int id) async {
    await _dataSource.deleteProducto(id);
  }
}