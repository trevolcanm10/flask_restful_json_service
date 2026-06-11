/// Entidad pura del dominio para el Usuario autenticado.
class User {
  final String username;
  final String token;

  const User({
    required this.username,
    required this.token,
  });
}