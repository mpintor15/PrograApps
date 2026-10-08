import '../repositories/auth_repository.dart';
import '../repositories/perfiles_repository.dart';

class RegistrarUsuario {
  final AuthRepository _auth;
  final PerfilesRepository _perfiles;

  const RegistrarUsuario(this._auth, this._perfiles);

  /// Crea la cuenta y luego su perfil. Si el segundo paso falla, propaga el error.
  Future<void> call(String correo, String clave, String nombre) async {
    final id = await _auth.registrar(correo, clave);
    await _perfiles.crear(id, nombre);
  }
}
