import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  final ConsultarConexion consultarConexion;

  const PantallaFoto({super.key, required this.consultarConexion});

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _hora;

  Future<void> _consultar() async {
    final estado = await widget.consultarConexion();
    if (!mounted) return;
    setState(() {
      _estado = estado;
      _hora = DateTime.now();
    });
  }

  String _formatoHora(DateTime t) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(t.hour)}:${dos(t.minute)}:${dos(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estado;
    final hora = _hora;
    final hayConexion = estado != null && estado != EstadoConexion.sinConexion;
    final color = hayConexion ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: const Text('Con Future')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (estado == null)
              const Text('Pulsa "Consultar ahora"')
            else ...[
              Icon(_icono(estado), size: 96, color: color),
              const SizedBox(height: 12),
              Text(
                _texto(estado),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: color),
              ),
              const SizedBox(height: 8),
              Text('Consultado a las ${_formatoHora(hora!)}'),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _consultar,
              child: const Text('Consultar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  static String _texto(EstadoConexion e) => switch (e) {
        EstadoConexion.wifi => 'Wi-Fi',
        EstadoConexion.datosMoviles => 'Datos móviles',
        EstadoConexion.otro => 'Otra conexión',
        EstadoConexion.sinConexion => 'Sin conexión',
      };

  static IconData _icono(EstadoConexion e) => switch (e) {
        EstadoConexion.wifi => Icons.wifi,
        EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
        EstadoConexion.otro => Icons.lan,
        EstadoConexion.sinConexion => Icons.wifi_off,
      };
}
