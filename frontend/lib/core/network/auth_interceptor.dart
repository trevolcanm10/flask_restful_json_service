import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

/// Interceptor de Dio que inyecta el JWT en cada petición
/// y detecta respuestas 401 para manejar sesiones expiradas.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final void Function()? onUnauthorized;

  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    this.onUnauthorized,
  }) : _secureStorage = secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: AppConstants.jwtTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.delete(key: AppConstants.jwtTokenKey);
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}