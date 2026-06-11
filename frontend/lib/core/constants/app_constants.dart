/// Constantes globales de la aplicación.
class AppConstants {
  // Nombre de la aplicación
  static const String appName = 'Gestión de Productos';

  // Claves para almacenamiento seguro
  static const String jwtTokenKey = 'jwt_token';
  static const String usernameKey = 'username';

  // Textos de la UI
  static const String loginTitle = 'Iniciar Sesión';
  static const String loginButton = 'Ingresar';
  static const String usernameLabel = 'Usuario';
  static const String passwordLabel = 'Contraseña';

  static const String productosTitle = 'Productos';
  static const String buscarHint = 'Buscar productos...';
  static const String crearProducto = 'Crear Producto';
  static const String editarProducto = 'Editar Producto';
  static const String detalleProducto = 'Detalle del Producto';
  static const String sinResultados = 'No se encontraron productos';
  static const String cerrarSesion = 'Cerrar Sesión';

  static const String nombreLabel = 'Nombre';
  static const String descripcionLabel = 'Descripción';
  static const String categoriaLabel = 'Categoría';
  static const String precioLabel = 'Precio';
  static const String stockLabel = 'Stock';
  static const String guardarButton = 'Guardar';
  static const String cancelarButton = 'Cancelar';
  static const String eliminarButton = 'Eliminar';

  // Mensajes
  static const String eliminarConfirmacion = '¿Estás seguro de eliminar este producto?';
  static const String productoEliminado = 'Producto eliminado correctamente';
  static const String errorCargar = 'Error al cargar los datos';
  static const String sesionExpirada = 'Sesión expirada. Inicia sesión nuevamente.';
  static const String camposRequeridos = 'Todos los campos son obligatorios';
}