import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

/// Caso de uso para obtener todos los productos.
class GetProductosUseCase {
  final ProductoRepository _repository;

  GetProductosUseCase(this._repository);

  Future<List<Producto>> execute() => _repository.getProductos();
}