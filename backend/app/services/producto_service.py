from app.models.producto_model import Producto
from app.repositories.producto_repository import ProductoRepository


class ProductoService:
    @staticmethod
    def listar():
        productos = ProductoRepository.listar(activos=True)
        return [producto.to_dict() for producto in productos]

    @staticmethod
    def obtener(producto_id: int):
        producto = ProductoRepository.buscar_por_id(producto_id)
        if not producto or not producto.activo:
            return None, "Producto no encontrado"
        return producto.to_dict(), None

    @staticmethod
    def buscar(texto: str):
        productos = ProductoRepository.buscar_por_nombre_o_categoria(texto)
        return [producto.to_dict() for producto in productos]

    @staticmethod
    def crear(data: dict):
        error = ProductoService._validar_producto(data)
        if error:
            return None, error

        producto = Producto(
            nombre=data["nombre"].strip(),
            descripcion=data.get("descripcion", ""),
            categoria=data["categoria"].strip(),
            precio=float(data["precio"]),
            stock=int(data["stock"])
        )
        producto = ProductoRepository.crear(producto)
        return producto.to_dict(), None

    @staticmethod
    def actualizar(producto_id: int, data: dict):
        producto = ProductoRepository.buscar_por_id(producto_id)
        if not producto or not producto.activo:
            return None, "Producto no encontrado"

        error = ProductoService._validar_producto(data, parcial=True)
        if error:
            return None, error

        if "nombre" in data:
            producto.nombre = data["nombre"].strip()
        if "descripcion" in data:
            producto.descripcion = data.get("descripcion", "")
        if "categoria" in data:
            producto.categoria = data["categoria"].strip()
        if "precio" in data:
            producto.precio = float(data["precio"])
        if "stock" in data:
            producto.stock = int(data["stock"])

        ProductoRepository.guardar()
        return producto.to_dict(), None

    @staticmethod
    def eliminar(producto_id: int):
        producto = ProductoRepository.buscar_por_id(producto_id)
        if not producto or not producto.activo:
            return None, "Producto no encontrado"

        producto = ProductoRepository.eliminar_logico(producto)
        return producto.to_dict(), None

    @staticmethod
    def _validar_producto(data: dict, parcial=False):
        campos_obligatorios = ["nombre", "categoria", "precio", "stock"]

        if not parcial:
            for campo in campos_obligatorios:
                if campo not in data:
                    return f"El campo '{campo}' es obligatorio"

        if "nombre" in data and not str(data["nombre"]).strip():
            return "El nombre no puede estar vacío"

        if "categoria" in data and not str(data["categoria"]).strip():
            return "La categoría no puede estar vacía"

        if "precio" in data:
            try:
                precio = float(data["precio"])
                if precio < 0:
                    return "El precio no puede ser negativo"
            except (TypeError, ValueError):
                return "El precio debe ser numérico"

        if "stock" in data:
            try:
                stock = int(data["stock"])
                if stock < 0:
                    return "El stock no puede ser negativo"
            except (TypeError, ValueError):
                return "El stock debe ser un número entero"

        return None
