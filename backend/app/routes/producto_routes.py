from flask import Blueprint
from flask_jwt_extended import jwt_required
from app.controllers.producto_controller import ProductoController

producto_bp = Blueprint("producto_bp", __name__)

producto_bp.get("")(ProductoController.listar)
producto_bp.get("/buscar")(ProductoController.buscar)
producto_bp.get("/<int:producto_id>")(ProductoController.obtener)

# Las operaciones que modifican datos requieren autenticación JWT.
producto_bp.post("")(jwt_required()(ProductoController.crear))
producto_bp.put("/<int:producto_id>")(jwt_required()(ProductoController.actualizar))
producto_bp.delete("/<int:producto_id>")(jwt_required()(ProductoController.eliminar))
