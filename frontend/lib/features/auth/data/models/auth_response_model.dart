import '../../domain/entities/user.dart';

/// Modelo de datos para la respuesta de autenticación.
class AuthResponseModel {
  final String accessToken;

  const AuthResponseModel({
    required this.accessToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String? ?? '',
    );
  }

  /// Convierte a entidad [User] del dominio.
  User toEntity(String username) {
    return User(
      username: username,
      token: accessToken,
    );
  }
}