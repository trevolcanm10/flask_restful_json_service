import '../entities/producto.dart';

/// Interfaz del repositorio de productos.
/// Define el contrato que debe implementar la capa de datos.
abstract class ProductoRepository {
  /// Obtiene todos los productos.
  Future<List<Producto>> getProductos();

  /// Busca productos por texto de búsqueda.
  Future<List<Producto>> searchProductos(String query);

  /// Obtiene un producto por su ID.
  Future<Producto> getProductoById(int id);

  /// Crea un nuevo producto.
  Future<Producto> createProducto(Map<String, dynamic> data);

  /// Actualiza un producto existente.
  Future<Producto> updateProducto(int id, Map<String, dynamic> data);

  /// Elimina un producto por su ID.
  Future<void> deleteProducto(int id);
}