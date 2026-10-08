import 'package:flutter/foundation.dart';

import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class PerfilesProvider extends ChangeNotifier {
  final PerfilesRepository _repositorio;

  PerfilesProvider(this._repositorio);

  List<Perfil> perfiles = [];
  bool cargando = false;
  String? error;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      perfiles = await _repositorio.obtenerTodos();
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }
}
