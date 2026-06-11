import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

/// Caso de uso para crear un nuevo producto.
class CreateProductoUseCase {
  final ProductoRepository _repository;

  CreateProductoUseCase(this._repository);

  Future<Producto> execute(Map<String, dynamic> data) =>
      _repository.createProducto(data);
}