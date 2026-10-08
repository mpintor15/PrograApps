import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioMemoria implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    return const [
      Usuario(id: 1, nombre: 'Ana Torres', email: 'ana@ejemplo.com'),
      Usuario(id: 2, nombre: 'Bruno Paredes', email: 'bruno@ejemplo.com'),
      Usuario(id: 3, nombre: 'Isabel Mena', email: 'isabel@ejemplo.com'),
    ];
  }
}
