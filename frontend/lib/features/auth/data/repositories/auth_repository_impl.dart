import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del repositorio de autenticación.
/// Conecta la fuente de datos remota con el almacenamiento local del token.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final DioClient _dioClient;

  AuthRepositoryImpl()
      : _remoteDataSource = AuthRemoteDataSource(),
        _dioClient = DioClient.instance;

  @override
  Future<User> login(String username, String password) async {
    final authResponse = await _remoteDataSource.login(username, password);
    final user = authResponse.toEntity(username);

    // Guardar el token JWT en almacenamiento seguro
    await _dioClient.saveToken(user.token);

    return user;
  }

  @override
  Future<void> logout() async {
    await _dioClient.clearToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _dioClient.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() async {
    return await _dioClient.getToken();
  }
}