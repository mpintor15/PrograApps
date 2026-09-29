import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contador_prefs_repository.dart';
import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>(
  (ref) => ContadorPrefsRepository(),
);

final obtenerContadorProvider = Provider(
  (ref) => ObtenerContador(ref.watch(contadorRepositoryProvider)),
);

final incrementarProvider = Provider(
  (ref) => Incrementar(ref.watch(contadorRepositoryProvider)),
);

final decrementarProvider = Provider(
  (ref) => Decrementar(ref.watch(contadorRepositoryProvider)),
);

class ContadorNotifier extends Notifier<int> {
  @override
  int build() {
    cargar();
    return 0;
  }

  Future<void> cargar() async {
    state = await ref.read(obtenerContadorProvider)();
  }

  Future<void> incrementar() async {
    state = await ref.read(incrementarProvider)();
  }

  Future<void> decrementar() async {
    state = await ref.read(decrementarProvider)();
  }
}

final contadorProvider =
    NotifierProvider<ContadorNotifier, int>(ContadorNotifier.new);
