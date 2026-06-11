from app.models.usuario_model import Usuario


class UsuarioRepository:
    @staticmethod
    def buscar_por_username(username: str):
        return Usuario.query.filter_by(username=username).first()

    @staticmethod
    def crear(usuario: Usuario):
        from app.extensions import db
        db.session.add(usuario)
        db.session.commit()
        return usuario
