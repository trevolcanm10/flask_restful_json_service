# Frontend Móvil — Flutter

Aplicación móvil desarrollada con **Flutter** que consume la API REST de productos protegida con JWT.

## 📱 Funcionalidades

- **Login**: Autenticación con JWT, almacenamiento seguro del token
- **Lista de Productos**: Búsqueda en tiempo real, pull-to-refresh, FAB para crear
- **Detalle de Producto**: Información completa con opciones de editar y eliminar
- **Crear/Editar**: Formulario con validación de campos

## 🧱 Arquitectura

- **Clean Architecture**: Separación en capas data, domain y presentation
- **MVVM**: View → ViewModel (Provider) → Model
- **GoRouter**: Navegación declarativa con redirect automático por autenticación
- **Dio**: Cliente HTTP con interceptor JWT y manejo de sesión expirada

## 🚀 Ejecutar

```bash
cd frontend
flutter pub get
flutter run
```

## 🔧 Construir APK

```bash
flutter build apk --release
```

El APK se genera en: `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Estructura principal

```
lib/
├── core/           # Configuración, red, rutas, tema, utilidades
├── features/
│   ├── auth/       # Login (data, domain, presentation)
│   └── productos/  # CRUD productos (data, domain, presentation)
└── main.dart       # Punto de entrada (Provider + GoRouter)