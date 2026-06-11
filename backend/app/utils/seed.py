from app.extensions import db
from app.models.usuario_model import Usuario
from app.models.producto_model import Producto


def seed_database():
    """Carga datos iniciales solo si la base de datos está vacía."""
    if not Usuario.query.filter_by(username="admin").first():
        admin = Usuario(
            username="admin",
            nombre="Administrador del sistema",
            rol="ADMIN",
            activo=True
        )
        admin.set_password("123456")
        db.session.add(admin)

    if Producto.query.count() == 0:
        productos = [
            Producto(
                nombre="Laptop Lenovo ThinkPad",
                descripcion="Equipo portátil para desarrollo y oficina",
                categoria="Tecnología",
                precio=3500.00,
                stock=8
            ),
            Producto(
                nombre="Mouse Logitech M185",
                descripcion="Mouse inalámbrico USB",
                categoria="Accesorios",
                precio=65.00,
                stock=25
            ),
            Producto(
                nombre="Teclado Mecánico Redragon",
                descripcion="Teclado mecánico para programación",
                categoria="Accesorios",
                precio=180.00,
                stock=15
            )
        ]
        db.session.add_all(productos)

    db.session.commit()
