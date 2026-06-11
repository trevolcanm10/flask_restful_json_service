from flask_jwt_extended import create_access_token
from app.repositories.usuario_repository import UsuarioRepository


class AuthService:
    @staticmethod
    def login(username: str, password: str):
        usuario = UsuarioRepository.buscar_por_username(username)

        if not usuario or not usuario.activo:
            return None, "Usuario no encontrado o inactivo"

        if not usuario.check_password(password):
            return None, "Credenciales incorrectas"

        token = create_access_token(
            identity=str(usuario.id),
            additional_claims={
                "username": usuario.username,
                "rol": usuario.rol
            }
        )

        return {
            "access_token": token,
            "token_type": "Bearer",
            "usuario": usuario.to_dict()
        }, None
