import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  final Connectivity _connectivity;

  ConexionPlusRepository({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<EstadoConexion> consultarAhora() async =>
      _traducir(await _connectivity.checkConnectivity());

  @override
  Stream<EstadoConexion> observarCambios() =>
      _connectivity.onConnectivityChanged.map(_traducir);

  // El paquete devuelve una lista: prioriza wifi, luego mobile; cualquier otro
  // transporte (ethernet, vpn, bluetooth...) es "otro"; sin nada, sinConexion.
  EstadoConexion _traducir(List<ConnectivityResult> resultados) {
    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }
    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    final hayOtro = resultados.any((r) => r != ConnectivityResult.none);
    return hayOtro ? EstadoConexion.otro : EstadoConexion.sinConexion;
  }
}
