from flask import jsonify, request
from app.services.auth_service import AuthService


class AuthController:
    @staticmethod
    def login():
        data = request.get_json(silent=True) or {}
        username = data.get("username", "").strip()
        password = data.get("password", "")

        if not username or not password:
            return jsonify({
                "success": False,
                "message": "Debe enviar username y password"
            }), 400

        resultado, error = AuthService.login(username, password)
        if error:
            return jsonify({
                "success": False,
                "message": error
            }), 401

        return jsonify({
            "success": True,
            "message": "Autenticación correcta",
            "data": resultado
        }), 200
