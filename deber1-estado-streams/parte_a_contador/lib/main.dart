import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/estado/contador_observer.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  Bloc.observer = ContadorObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repositorio = ContadorPrefsRepository();
        return ContadorCubit(
          ObtenerContador(repositorio),
          Incrementar(repositorio),
          Decrementar(repositorio),
        )..cargar();
      },
      child: MaterialApp(
        title: 'Contador',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const PantallaVisor(),
      ),
    );
  }
}
