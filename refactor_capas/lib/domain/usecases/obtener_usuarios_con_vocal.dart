import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  final UsuarioRepository _repositorio;

  const ObtenerUsuariosConVocal(this._repositorio);

  Future<List<Usuario>> call() async {
    final usuarios = await _repositorio.obtener();
    return usuarios.where(_empiezaConVocal).toList();
  }

  bool _empiezaConVocal(Usuario usuario) {
    final nombre = usuario.nombre.trim();
    if (nombre.isEmpty) return false;
    return 'aeiou'.contains(nombre[0].toLowerCase());
  }
}
