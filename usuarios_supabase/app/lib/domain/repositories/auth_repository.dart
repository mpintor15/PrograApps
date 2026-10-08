abstract class AuthRepository {
  /// Devuelve el id del usuario creado.
  Future<String> registrar(String correo, String clave);
  Future<void> ingresar(String correo, String clave);
  Future<void> salir();
  String? obtenerIdActual();
}
