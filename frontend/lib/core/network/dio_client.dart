import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import 'auth_interceptor.dart';

/// Cliente HTTP singleton basado en Dio.
/// Configura la URL base y los interceptores de autenticación.
class DioClient {
  static DioClient? _instance;
  late final Dio dio;
  late final FlutterSecureStorage secureStorage;
  void Function()? onUnauthorized;

  DioClient._() {
    secureStorage = const FlutterSecureStorage();

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        onUnauthorized: () => onUnauthorized?.call(),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// Obtiene la instancia única de DioClient.
  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  /// Limpia el token almacenado.
  Future<void> clearToken() async {
    await secureStorage.deleteAll();
  }

  /// Guarda el token JWT.
  Future<void> saveToken(String token) async {
    await secureStorage.write(
      key: 'jwt_token',
      value: token,
    );
  }

  /// Obtiene el token JWT almacenado.
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }
}