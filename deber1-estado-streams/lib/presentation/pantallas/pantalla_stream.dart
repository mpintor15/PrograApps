import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Con Stream')),
        body: Center(
          child: BlocBuilder<ConexionCubit, EstadoConexion>(
            builder: (context, estado) {
              final hayConexion = estado != EstadoConexion.sinConexion;
              final color = hayConexion ? Colors.green : Colors.red;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_icono(estado), size: 96, color: color),
                  const SizedBox(height: 12),
                  Text(
                    _texto(estado),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cambios recibidos: ${context.read<ConexionCubit>().cambios}',
                  ),
                ],
              );
            },
          ),
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
