/// Configuración centralizada de la API.
/// Cambiar [baseUrl] según el entorno (local, emulador, producción).
class ApiConfig {
  /// URL base de la API desplegada en Render.
  /// Cambiar según el entorno (local, emulador, producción).
  ///
  /// LOCAL:
  ///   - Emulador Android: http://10.0.2.2:5000/api
  ///   - Web/navegador:    http://localhost:5000/api
  ///   - Dispositivo físico: http://<IP_DEL_SERVIDOR>:5000/api
  ///
  /// PRODUCCIÓN (Render):
  static const String baseUrl =
      "https://flask-restful-json-service-r29b.onrender.com/api";

  // Endpoints de autenticación
  static const String loginEndpoint = "/auth/login";

  // Endpoints de productos
  static const String productosEndpoint = "/productos";
  static const String productosBuscarEndpoint = "/productos/buscar";
}

/// Estructura esperada de las respuestas de la API.
class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final int? total;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.total,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
      total: json['total'] as int?,
    );
  }
}