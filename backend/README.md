# Servicio Web RESTful con Flask y JSON

Proyecto académico de backend desarrollado con **Flask**, usando el estilo **RESTful** y respuestas en **JSON**. Está preparado para ser probado con Postman, Thunder Client o consumido desde una aplicación móvil en Flutter.

## 1. Características

- Framework: Flask.
- Formato de intercambio: JSON.
- Base de datos: SQLite.
- ORM: Flask-SQLAlchemy.
- CORS habilitado para consumo desde Flutter u otros clientes.
- Autenticación con JWT.
- Arquitectura por capas tipo MVC:
  - `models`: entidades de base de datos.
  - `repositories`: acceso a datos.
  - `services`: lógica de negocio.
  - `controllers`: control de solicitudes y respuestas.
  - `routes`: definición de endpoints.

## 2. Estructura del proyecto

```text
flask_restful_json_service/
│
├── app/
│   ├── controllers/
│   │   ├── auth_controller.py
│   │   └── producto_controller.py
│   ├── models/
│   │   ├── usuario_model.py
│   │   └── producto_model.py
│   ├── repositories/
│   │   ├── usuario_repository.py
│   │   └── producto_repository.py
│   ├── routes/
│   │   ├── auth_routes.py
│   │   └── producto_routes.py
│   ├── services/
│   │   ├── auth_service.py
│   │   └── producto_service.py
│   ├── utils/
│   │   └── seed.py
│   ├── config.py
│   ├── extensions.py
│   └── __init__.py
│
├── run.py
├── requirements.txt
├── test_api.http
├── .env.example
└── README.md
```

## 3. Instalación en Windows

```bash
cd flask_restful_json_service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
python run.py
```

## 4. Instalación en Linux o macOS

```bash
cd flask_restful_json_service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python run.py
```

## 5. URL base

```text
http://localhost:5000
```

Para emulador Android de Flutter:

```dart
const String baseUrl = 'http://10.0.2.2:5000/api';
```

Para celular físico, reemplazar `localhost` o `10.0.2.2` por la IP local de la computadora donde se ejecuta Flask.

## 6. Usuario de prueba

```text
Usuario: admin
Clave: 123456
```

## 7. Endpoints RESTful

### Estado del servicio

```http
GET /api/health
```

### Login

```http
POST /api/auth/login
Content-Type: application/json
```

Body:

```json
{
  "username": "admin",
  "password": "123456"
}
```

Respuesta esperada:

```json
{
  "success": true,
  "message": "Autenticación correcta",
  "data": {
    "access_token": "TOKEN_GENERADO",
    "token_type": "Bearer",
    "usuario": {
      "id": 1,
      "username": "admin",
      "nombre": "Administrador del sistema",
      "rol": "ADMIN",
      "activo": true
    }
  }
}
```

### Listar productos

```http
GET /api/productos
```

### Buscar productos

```http
GET /api/productos/buscar?q=laptop
```

### Obtener producto por ID

```http
GET /api/productos/1
```

### Crear producto

Requiere token JWT.

```http
POST /api/productos
Authorization: Bearer TOKEN_AQUI
Content-Type: application/json
```

Body:

```json
{
  "nombre": "Monitor LG 24 pulgadas",
  "descripcion": "Monitor Full HD para oficina",
  "categoria": "Tecnología",
  "precio": 620.50,
  "stock": 12
}
```

### Actualizar producto

Requiere token JWT.

```http
PUT /api/productos/1
Authorization: Bearer TOKEN_AQUI
Content-Type: application/json
```

Body:

```json
{
  "precio": 3399.90,
  "stock": 10
}
```

### Eliminar producto

Requiere token JWT. Se realiza eliminación lógica, cambiando `activo` a `false`.

```http
DELETE /api/productos/1
Authorization: Bearer TOKEN_AQUI
```

## 8. Ejemplo de consumo desde Flutter

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<dynamic>> listarProductos() async {
    final response = await http.get(Uri.parse('$baseUrl/productos'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    throw Exception('Error al listar productos');
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['access_token'];
    }

    throw Exception('Credenciales incorrectas');
  }
}
```

## 9. Diferencia con SOAP-XML

Este proyecto no utiliza SOAP ni XML. Utiliza el enfoque RESTful, donde las operaciones se exponen mediante rutas HTTP y los datos se intercambian en formato JSON.

Ejemplo RESTful JSON:

```json
{
  "id": 1,
  "nombre": "Laptop Lenovo ThinkPad",
  "categoria": "Tecnología",
  "precio": 3500.00
}
```
