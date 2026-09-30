import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() {
  final repositorio = ConexionPlusRepository();
  runApp(MyApp(
    consultarConexion: ConsultarConexion(repositorio),
    observarConexion: ObservarConexion(repositorio),
  ));
}

class MyApp extends StatelessWidget {
  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  const MyApp({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexión',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: Inicio(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  const Inicio({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    // Sin IndexedStack: al salir de la pestaña "Con Stream" se destruye la
    // pantalla y el Cubit se cierra (close()).
    final pantalla = _indice == 0
        ? PantallaFoto(consultarConexion: widget.consultarConexion)
        : PantallaStream(
            consultarConexion: widget.consultarConexion,
            observarConexion: widget.observarConexion,
          );
    return Scaffold(
      body: pantalla,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Con Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Con Stream',
          ),
        ],
      ),
    );
  }
}
