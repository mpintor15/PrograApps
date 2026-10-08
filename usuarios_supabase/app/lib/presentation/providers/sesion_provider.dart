import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/registrar_usuario.dart';

class SesionProvider extends ChangeNotifier {
  final AuthRepository _auth;
  final RegistrarUsuario _registrarUsuario;

  SesionProvider(this._auth, this._registrarUsuario)
      : idUsuario = _auth.obtenerIdActual();

  String? idUsuario;
  bool cargando = false;
  String? error;

  Future<void> registrar(String correo, String clave, String nombre) {
    return _ejecutar(() async {
      await _registrarUsuario(correo, clave, nombre);
      idUsuario = _auth.obtenerIdActual();
    });
  }

  Future<void> ingresar(String correo, String clave) {
    return _ejecutar(() async {
      await _auth.ingresar(correo, clave);
      idUsuario = _auth.obtenerIdActual();
    });
  }

  Future<void> salir() {
    return _ejecutar(() async {
      await _auth.salir();
      idUsuario = null;
    });
  }

  Future<void> _ejecutar(Future<void> Function() operacion) async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      await operacion();
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }
}
