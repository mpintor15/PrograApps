import 'package:flutter/material.dart';

import '../domain/entities/usuario.dart';
import '../domain/usecases/obtener_usuarios_con_vocal.dart';

class PantallaUsuarios extends StatefulWidget {
  final ObtenerUsuariosConVocal obtenerUsuarios;

  const PantallaUsuarios({super.key, required this.obtenerUsuarios});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  List<Usuario> usuarios = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      final resultado = await widget.obtenerUsuarios();
      if (!mounted) return;
      setState(() {
        usuarios = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'No se pudieron cargar los usuarios';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios con vocal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargando ? null : cargar,
          ),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(error!, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: CircleAvatar(child: Text('${usuarios[i].id}')),
                    title: Text(usuarios[i].nombre),
                    subtitle: Text(usuarios[i].email),
                  ),
                ),
    );
  }
}
