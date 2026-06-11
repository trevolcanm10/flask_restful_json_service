import '../repositories/producto_repository.dart';

/// Caso de uso para eliminar un producto.
class DeleteProductoUseCase {
  final ProductoRepository _repository;

  DeleteProductoUseCase(this._repository);

  Future<void> execute(int id) => _repository.deleteProducto(id);
}