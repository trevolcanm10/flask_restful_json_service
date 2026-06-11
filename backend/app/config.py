import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "clave-secreta-desarrollo")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "clave-jwt-desarrollo")
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "sqlite:///servicio_web.db")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JSON_SORT_KEYS = False
