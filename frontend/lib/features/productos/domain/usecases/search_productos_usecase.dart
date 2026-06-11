import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

/// Caso de uso para buscar productos por texto.
class SearchProductosUseCase {
  final ProductoRepository _repository;

  SearchProductosUseCase(this._repository);

  Future<List<Producto>> execute(String query) =>
      _repository.searchProductos(query);
}