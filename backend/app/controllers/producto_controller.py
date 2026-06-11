from flask import jsonify, request
from app.services.producto_service import ProductoService


class ProductoController:
    @staticmethod
    def listar():
        productos = ProductoService.listar()
        return jsonify({
            "success": True,
            "message": "Productos obtenidos correctamente",
            "total": len(productos),
            "data": productos
        }), 200

    @staticmethod
    def obtener(producto_id: int):
        producto, error = ProductoService.obtener(producto_id)
        if error:
            return jsonify({
                "success": False,
                "message": error
            }), 404

        return jsonify({
            "success": True,
            "message": "Producto obtenido correctamente",
            "data": producto
        }), 200

    @staticmethod
    def buscar():
        texto = request.args.get("q", "").strip()
        if not texto:
            return jsonify({
                "success": False,
                "message": "Debe enviar el parámetro de búsqueda q"
            }), 400

        productos = ProductoService.buscar(texto)
        return jsonify({
            "success": True,
            "message": "Búsqueda realizada correctamente",
            "total": len(productos),
            "data": productos
        }), 200

    @staticmethod
    def crear():
        data = request.get_json(silent=True) or {}
        producto, error = ProductoService.crear(data)
        if error:
            return jsonify({
                "success": False,
                "message": error
            }), 400

        return jsonify({
            "success": True,
            "message": "Producto creado correctamente",
            "data": producto
        }), 201

    @staticmethod
    def actualizar(producto_id: int):
        data = request.get_json(silent=True) or {}
        producto, error = ProductoService.actualizar(producto_id, data)
        if error:
            status_code = 404 if "no encontrado" in error.lower() else 400
            return jsonify({
                "success": False,
                "message": error
            }), status_code

        return jsonify({
            "success": True,
            "message": "Producto actualizado correctamente",
            "data": producto
        }), 200

    @staticmethod
    def eliminar(producto_id: int):
        producto, error = ProductoService.eliminar(producto_id)
        if error:
            return jsonify({
                "success": False,
                "message": error
            }), 404

        return jsonify({
            "success": True,
            "message": "Producto eliminado correctamente",
            "data": producto
        }), 200
