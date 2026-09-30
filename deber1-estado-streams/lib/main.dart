import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';

void main() {
  final repositorio = ConexionPlusRepository();
  runApp(MyApp(consultarConexion: ConsultarConexion(repositorio)));
}

class MyApp extends StatelessWidget {
  final ConsultarConexion consultarConexion;

  const MyApp({super.key, required this.consultarConexion});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexión',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: PantallaFoto(consultarConexion: consultarConexion),
    );
  }
}
