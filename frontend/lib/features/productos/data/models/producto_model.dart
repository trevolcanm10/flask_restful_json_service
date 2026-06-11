import '../../domain/entities/producto.dart';

/// Modelo de datos para Producto con serialización JSON.
/// Extiende la entidad [Producto] para agregar capacidades de
/// serialización/deserialización sin contaminar la capa de dominio.
class ProductoModel extends Producto {
  const ProductoModel({
    required super.id,
    required super.nombre,
    super.descripcion,
    required super.categoria,
    required super.precio,
    required super.stock,
    super.activo,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      categoria: json['categoria'] as String? ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
    };
  }

  /// Convierte el modelo a una entidad [Producto] pura.
  Producto toEntity() {
    return Producto(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria,
      precio: precio,
      stock: stock,
      activo: activo,
    );
  }

  /// Crea un modelo desde una entidad [Producto].
  factory ProductoModel.fromEntity(Producto entity) {
    return ProductoModel(
      id: entity.id,
      nombre: entity.nombre,
      descripcion: entity.descripcion,
      categoria: entity.categoria,
      precio: entity.precio,
      stock: entity.stock,
      activo: entity.activo,
    );
  }
}