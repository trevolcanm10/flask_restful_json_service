from sqlalchemy import or_
from app.extensions import db
from app.models.producto_model import Producto


class ProductoRepository:
    @staticmethod
    def listar(activos=True):
        query = Producto.query
        if activos:
            query = query.filter_by(activo=True)
        return query.order_by(Producto.id.desc()).all()

    @staticmethod
    def buscar_por_id(producto_id: int):
        return Producto.query.get(producto_id)

    @staticmethod
    def buscar_por_nombre_o_categoria(texto: str):
        patron = f"%{texto}%"
        return Producto.query.filter(
            Producto.activo.is_(True),
            or_(
                Producto.nombre.ilike(patron),
                Producto.categoria.ilike(patron)
            )
        ).order_by(Producto.id.desc()).all()

    @staticmethod
    def crear(producto: Producto):
        db.session.add(producto)
        db.session.commit()
        return producto

    @staticmethod
    def guardar():
        db.session.commit()

    @staticmethod
    def eliminar_logico(producto: Producto):
        producto.activo = False
        db.session.commit()
        return producto
