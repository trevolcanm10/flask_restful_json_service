import '../entities/user.dart';

/// Interfaz del repositorio de autenticación.
/// Define el contrato que debe implementar la capa de datos.
abstract class AuthRepository {
  /// Intenta iniciar sesión con [username] y [password].
  /// Retorna un [User] si la autenticación es exitosa.
  Future<User> login(String username, String password);

  /// Cierra la sesión actual limpiando el token.
  Future<void> logout();

  /// Verifica si hay un token de acceso almacenado.
  Future<bool> isAuthenticated();

  /// Obtiene el token de acceso almacenado.
  Future<String?> getToken();
}