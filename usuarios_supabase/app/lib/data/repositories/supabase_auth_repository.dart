import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  GoTrueClient get _auth => Supabase.instance.client.auth;

  @override
  Future<String> registrar(String correo, String clave) async {
    final respuesta = await _auth.signUp(email: correo, password: clave);
    final usuario = respuesta.user;
    if (usuario == null) {
      throw Exception('No se pudo crear la cuenta');
    }
    return usuario.id;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    await _auth.signInWithPassword(email: correo, password: clave);
  }

  @override
  Future<void> salir() => _auth.signOut();

  @override
  String? obtenerIdActual() => _auth.currentUser?.id;
}
