import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

/// Caso de uso para actualizar un producto existente.
class UpdateProductoUseCase {
  final ProductoRepository _repository;

  UpdateProductoUseCase(this._repository);

  Future<Producto> execute(int id, Map<String, dynamic> data) =>
      _repository.updateProducto(id, data);
}