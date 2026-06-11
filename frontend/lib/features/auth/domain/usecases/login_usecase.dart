import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para el inicio de sesión.
/// Orquesta la lógica de negocio del login.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Ejecuta el login con [username] y [password].
  Future<User> execute(String username, String password) {
    return _repository.login(username, password);
  }
}