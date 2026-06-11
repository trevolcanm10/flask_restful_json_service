import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';

/// ViewModel de autenticación. Gestiona el estado del login.
/// Implementa ChangeNotifier para notificar cambios a la UI.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  late final LoginUseCase _loginUseCase;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  AuthViewModel()
      : _repository = AuthRepositoryImpl() {
    _loginUseCase = LoginUseCase(_repository);
    _checkAuth();
  }

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// Verifica si hay un token almacenado al iniciar.
  Future<void> _checkAuth() async {
    _isAuthenticated = await _repository.isAuthenticated();
    notifyListeners();
  }

  /// Intenta iniciar sesión con las credenciales proporcionadas.
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loginUseCase.execute(username, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isAuthenticated = false;
      _isLoading = false;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Cierra la sesión actual.
  Future<void> logout() async {
    await _repository.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Obtiene el token actual.
  Future<String?> getToken() => _repository.getToken();

  /// Verifica si hay sesión activa.
  Future<bool> checkAuthenticated() => _repository.isAuthenticated();

  /// Parsea errores de la API a mensajes legibles.
  String _parseError(dynamic error) {
    // Si es un DioException, extraer el mensaje del response
    if (error is DioException) {
      // Extraer mensaje del cuerpo de la respuesta si existe
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      // Si hay un mensaje personalizado en la excepción
      if (error.message != null && error.message!.isNotEmpty) {
        // Manejar errores comunes por código de estado
        switch (error.response?.statusCode) {
          case 401:
            return 'Credenciales incorrectas';
          case 400:
            return error.message!;
          case 404:
            return 'Servicio no disponible';
          case 500:
            return 'Error interno del servidor';
          default:
            return error.message!;
        }
      }

      // Manejar errores de conexión
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Tiempo de espera agotado. Verifica tu conexión.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'No se puede conectar al servidor. Asegúrate de que el backend esté ejecutándose.';
      }
    }

    // Para otros tipos de error
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
      return 'Credenciales incorrectas';
    }
    if (errorStr.contains('404')) {
      return 'Servicio no disponible';
    }
    if (errorStr.contains('timeout')) {
      return 'Tiempo de espera agotado';
    }
    return 'Error al conectar con el servidor';
  }
}