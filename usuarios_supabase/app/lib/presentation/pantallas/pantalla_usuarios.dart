import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'pantalla_ingreso.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilesProvider>().cargar();
    });
  }

  Future<void> _cerrarSesion() async {
    await context.read<SesionProvider>().salir();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PantallaIngreso()),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final f = fecha.toLocal();
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(f.day)}/${dos(f.month)}/${f.year} ${dos(f.hour)}:${dos(f.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final perfiles = context.watch<PerfilesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios registrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PerfilesProvider>().cargar(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: perfiles.cargando
          ? const Center(child: CircularProgressIndicator())
          : perfiles.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      perfiles.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: perfiles.perfiles.length,
                  itemBuilder: (context, i) {
                    final perfil = perfiles.perfiles[i];
                    return ListTile(
                      title: Text(perfil.nombre),
                      subtitle: Text(_formatearFecha(perfil.creadoEn)),
                    );
                  },
                ),
    );
  }
}
