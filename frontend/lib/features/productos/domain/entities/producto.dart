/// Entidad pura del dominio para Producto.
/// No depende de ningún framework ni de la capa de datos.
class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final String categoria;
  final double precio;
  final int stock;
  final bool activo;

  const Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.activo = true,
  });
}