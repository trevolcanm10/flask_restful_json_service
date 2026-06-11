import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

/// Fuente de datos remota para autenticación.
/// Comunica con la API REST de login.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource() : _dio = DioClient.instance.dio;

  /// Envía credenciales al endpoint de login.
  /// La API retorna: { "success": true, "message": "...", "data": { "access_token": "..." } }
  Future<AuthResponseModel> login(String username, String password) async {
    final response = await _dio.post(
      ApiConfig.loginEndpoint,
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      
      // Validar que la respuesta sea exitosa
      if (data['success'] == true && data['data'] != null) {
        final responseData = data['data'] as Map<String, dynamic>;
        return AuthResponseModel.fromJson(responseData);
      }
      
      // Si el backend retorna success: false, lanzar error con el mensaje
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: data['message'] as String? ?? 'Error en la autenticación',
      );
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Error inesperado al iniciar sesión',
    );
  }
}