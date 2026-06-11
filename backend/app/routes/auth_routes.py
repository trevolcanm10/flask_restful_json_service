from flask import Blueprint
from app.controllers.auth_controller import AuthController

auth_bp = Blueprint("auth_bp", __name__)

auth_bp.post("/login")(AuthController.login)
