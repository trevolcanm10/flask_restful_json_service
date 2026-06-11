import 'package:dio/dio.dart';
import '../models/producto_model.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';

/// Fuente de datos remota para productos.
/// Comunica con la API REST de productos.
class ProductoRemoteDataSource {
  final Dio _dio;

  ProductoRemoteDataSource() : _dio = DioClient.instance.dio;

  /// Obtiene todos los productos.
  Future<List<ProductoModel>> getProductos() async {
    final response = await _dio.get(ApiConfig.productosEndpoint);
    final List data = response.data['data'] as List;
    return data.map((json) => ProductoModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Busca productos por texto.
  Future<List<ProductoModel>> searchProductos(String query) async {
    final response = await _dio.get(
      ApiConfig.productosBuscarEndpoint,
      queryParameters: {'q': query},
    );
    final List data = response.data['data'] as List;
    return data.map((json) => ProductoModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtiene un producto por su ID.
  Future<ProductoModel> getProductoById(int id) async {
    final response = await _dio.get('${ApiConfig.productosEndpoint}/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return ProductoModel.fromJson(data);
  }

  /// Crea un nuevo producto.
  Future<ProductoModel> createProducto(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConfig.productosEndpoint, data: data);
    final responseData = response.data['data'] as Map<String, dynamic>;
    return ProductoModel.fromJson(responseData);
  }

  /// Actualiza un producto existente.
  Future<ProductoModel> updateProducto(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiConfig.productosEndpoint}/$id', data: data);
    final responseData = response.data['data'] as Map<String, dynamic>;
    return ProductoModel.fromJson(responseData);
  }

  /// Elimina un producto por su ID.
  Future<void> deleteProducto(int id) async {
    await _dio.delete('${ApiConfig.productosEndpoint}/$id');
  }
}