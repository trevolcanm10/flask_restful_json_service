# Flask RESTful JSON Service

[![Flask](https://img.shields.io/badge/Flask-3.x-000000?logo=flask)](https://flask.palletsprojects.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 📋 Descripción

Proyecto académico full-stack que implementa un **servicio web RESTful con Flask** (backend) y una **aplicación móvil Flutter** (frontend) para la gestión de productos con autenticación JWT.

### Funcionalidades principales

- ✅ Autenticación segura con **JWT** (JSON Web Tokens)
- ✅ CRUD completo de productos (Crear, Leer, Actualizar, Eliminar)
- ✅ Búsqueda de productos por texto
- ✅ Protección de endpoints con JWT
- ✅ Frontend moderno con **Clean Architecture + MVVM**
- ✅ Gestión de estado con **Provider**
- ✅ Interceptor HTTP que inyecta el token automáticamente
- ✅ Manejo de sesión expirada y redirección al login

---

## 🏗️ Arquitectura del Proyecto

```
flask_restful_json_service/
│
├── backend/                    # API REST con Flask
│   ├── app/
│   │   ├── controllers/        # Manejo de solicitudes HTTP
│   │   ├── models/             # Entidades de base de datos
│   │   ├── repositories/       # Acceso a datos
│   │   ├── routes/             # Definición de endpoints
│   │   ├── services/           # Lógica de negocio
│   │   └── utils/              # Utilidades (seed data)
│   ├── run.py                  # Punto de entrada
│   ├── requirements.txt        # Dependencias Python
│   └── README.md               # Documentación del backend
│
├── frontend/                   # App móvil con Flutter
│   ├── lib/
│   │   ├── core/               # Capa transversal
│   │   │   ├── config/         # Configuración de API
│   │   │   ├── constants/      # Constantes de la app
│   │   │   ├── network/        # Cliente HTTP (Dio + interceptores)
│   │   │   ├── routes/         # GoRouter (navegación)
│   │   │   ├── theme/          # Tema y estilos
│   │   │   └── utils/          # Utilidades (Snackbars)
│   │   ├── features/
│   │   │   ├── auth/           # Módulo de autenticación
│   │   │   │   ├── data/       # DataSources, Models, Repositorios
│   │   │   │   ├── domain/     # Entidades, Interfaces, UseCases
│   │   │   │   └── presentation/ # ViewModel, Views, Widgets
│   │   │   └── productos/      # Módulo de productos
│   │   │       ├── data/       # DataSources, Models, Repositorios
│   │   │       ├── domain/     # Entidades, Interfaces, UseCases
│   │   │       └── presentation/ # ViewModel, Views, Widgets
│   │   └── main.dart           # Punto de entrada
│   └── pubspec.yaml            # Dependencias Dart/Flutter
│
├── .gitignore                  # Archivos ignorados por Git
└── README.md                   # Este archivo
```

---

## 🚀 Tecnologías Utilizadas

### Backend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Python | 3.10+ | Lenguaje de programación |
| Flask | 3.x | Framework web |
| Flask-JWT-Extended | 4.x | Autenticación JWT |
| Flask-SQLAlchemy | 3.x | ORM para base de datos |
| Flask-Cors | 4.x | Habilitar CORS |
| SQLite | - | Base de datos (desarrollo) |
| Gunicorn | - | Servidor WSGI (producción) |

### Frontend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Flutter | 3.x | Framework de UI móvil |
| Dart | 3.x | Lenguaje de programación |
| Dio | 5.x | Cliente HTTP con interceptores |
| Provider | 6.x | State management (MVVM) |
| GoRouter | 14.x | Navegación declarativa |
| flutter_secure_storage | 9.x | Almacenamiento seguro de JWT |
| intl | 0.19.x | Formateo de moneda y fechas |

---

## ⚙️ Instalación y Ejecución Local

### Prerrequisitos

- Python 3.10 o superior
- Flutter SDK 3.x
- Git

### 1. Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/flask_restful_json_service.git
cd flask_restful_json_service
```

### 2. Backend (Flask API)

```bash
cd backend

# Crear y activar entorno virtual
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/macOS
# source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# (Opcional) Crear archivo .env
copy .env.example .env   # Windows
# cp .env.example .env    # Linux/macOS

# Ejecutar servidor
python run.py
```

El servidor se iniciará en `http://localhost:5000`.

### 3. Frontend (Flutter App)

```bash
cd frontend

# Instalar dependencias
flutter pub get

# Ejecutar en emulador o dispositivo
flutter run
```

> **Nota**: Si usas emulador Android, la URL base (`baseUrl`) en `lib/core/config/api_config.dart` debe ser `http://10.0.2.2:5000/api`. Para web/navegador usa `http://localhost:5000/api`.

---

## 🔐 Credenciales de Prueba

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| `admin` | `123456` | ADMIN |

---

## 📡 Endpoints de la API

### Autenticación

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| `POST` | `/api/auth/login` | No | Iniciar sesión |

### Productos

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| `GET` | `/api/productos` | No | Listar todos los productos |
| `GET` | `/api/productos/{id}` | No | Obtener producto por ID |
| `GET` | `/api/productos/buscar?q=` | No | Buscar productos por texto |
| `POST` | `/api/productos` | JWT | Crear nuevo producto |
| `PUT` | `/api/productos/{id}` | JWT | Actualizar producto |
| `DELETE` | `/api/productos/{id}` | JWT | Eliminar producto |

### Ejemplo de respuesta exitosa

```json
{
  "success": true,
  "message": "Productos obtenidos correctamente",
  "total": 3,
  "data": [
    {
      "id": 1,
      "nombre": "Laptop Lenovo ThinkPad",
      "descripcion": "Equipo portátil para desarrollo y oficina",
      "categoria": "Tecnología",
      "precio": 3500.0,
      "stock": 8,
      "activo": true
    }
  ]
}
```

---

## 📱 Frontend — Pantallas

| Pantalla | Descripción |
|----------|-------------|
| **Login** | Interfaz con gradiente, formulario con validación, JWT persistente |
| **Lista de Productos** | Listado con búsqueda en tiempo real, pull-to-refresh, FAB para crear |
| **Detalle de Producto** | Información completa con opciones de editar y eliminar |
| **Crear/Editar Producto** | Formulario con validación de campos |

### Funcionalidades clave

- 🔍 **Búsqueda instantánea** de productos
- 🔄 **Pull-to-refresh** para recargar datos
- 🛡️ **Manejo de sesión**: token expirado → redirección automática al login
- 📱 **Diseño responsive** y moderno

---

## 🧱 Arquitectura del Frontend (Clean Architecture + MVVM)

```
lib/
├── core/                           # Capa transversal
│   ├── config/api_config.dart      # Configuración de la API
│   ├── network/dio_client.dart     # Cliente HTTP singleton
│   ├── network/auth_interceptor.dart # Interceptor JWT
│   └── routes/app_router.dart      # GoRouter con auth redirect
│
└── features/                       # Módulos de la aplicación
    └── auth/ o productos/
        ├── data/                   # Capa de datos
        │   ├── datasources/        # Llamadas HTTP (Dio)
        │   ├── models/             # Modelos serializables
        │   └── repositories/       # Implementación de repositorios
        │
        ├── domain/                 # Capa de dominio (pura)
        │   ├── entities/           # Entidades sin dependencias
        │   ├── repositories/       # Interfaces abstractas
        │   └── usecases/           # Casos de uso
        │
        └── presentation/           # Capa de presentación (MVVM)
            ├── viewmodels/         # ChangeNotifier (estado)
            ├── views/              # Pantallas (Widgets)
            └── widgets/            # Componentes reutilizables
```

**Flujo de datos:**
```
View (Widget) → ViewModel (ChangeNotifier) → UseCase → Repository (abstract)
                                                              ↓
                                                    RepositoryImpl → DataSource (Dio) → API
```

---

## 🚀 Despliegue en Render

### Backend

1. Subir el proyecto a GitHub
2. En [Render](https://dashboard.render.com), crear un **Web Service**
3. Conectar el repositorio de GitHub
4. Configurar:
   - **Root Directory**: `backend`
   - **Runtime**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn run:app --bind 0.0.0.0:$PORT`
5. Agregar variables de entorno en Render:
   - `SECRET_KEY`: (clave secreta)
   - `JWT_SECRET_KEY`: (clave secreta JWT)
   - `FLASK_ENV`: `production`

### Frontend

El frontend Flutter no se despliega en Render. Debes:

1. Actualizar `lib/core/config/api_config.dart` con la URL de Render
2. Compilar el APK: `flutter build apk --release`
3. Distribuir el APK generado en `build/app/outputs/flutter-apk/app-release.apk`

---

## 📄 Licencia

Proyecto académico — Universidad.

---

## 👨‍💻 Autor

Desarrollado como parte del curso de Servicios Web.