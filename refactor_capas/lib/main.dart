import 'package:flutter/material.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/pantalla_usuarios.dart';

void main() {
  final repositorio = UsuarioMemoria();
  final obtenerUsuarios = ObtenerUsuariosConVocal(repositorio);

  runApp(MyApp(obtenerUsuarios: obtenerUsuarios));
}

class MyApp extends StatelessWidget {
  final ObtenerUsuariosConVocal obtenerUsuarios;

  const MyApp({super.key, required this.obtenerUsuarios});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuarios',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: PantallaUsuarios(obtenerUsuarios: obtenerUsuarios),
    );
  }
}
