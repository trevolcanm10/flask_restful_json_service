from flask import Flask, jsonify
from .config import Config
from .extensions import db, cors, jwt
from .routes.auth_routes import auth_bp
from .routes.producto_routes import producto_bp
from .utils.seed import seed_database


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    cors.init_app(app, resources={r"/api/*": {"origins": "*"}})
    jwt.init_app(app)

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(producto_bp, url_prefix="/api/productos")

    @app.get("/")
    def index():
        return jsonify({
            "mensaje": "Servicio Web RESTful con Flask y JSON",
            "version": "1.0.0",
            "documentacion": "/api/health"
        }), 200

    @app.get("/api/health")
    def health():
        return jsonify({
            "status": "ok",
            "servicio": "flask-restful-json-service"
        }), 200

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            "error": "Recurso no encontrado",
            "detalle": str(error)
        }), 404

    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({
            "error": "Error interno del servidor",
            "detalle": str(error)
        }), 500

    with app.app_context():
        db.create_all()
        seed_database()

    return app
