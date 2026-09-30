import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;

  /// Cambios recibidos por el stream desde que se llamó a [iniciar].
  int cambios = 0;

  ConexionCubit(this._consultarConexion, this._observarConexion)
      : super(EstadoConexion.otro);

  Future<void> iniciar() async {
    emit(await _consultarConexion());
    await _suscripcion?.cancel();
    _suscripcion = _observarConexion().listen((estado) {
      cambios++;
      emit(estado);
    });
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    return super.close();
  }
}
