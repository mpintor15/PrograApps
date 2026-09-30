import '../repositories/contador_repository.dart';

class Incrementar {
  final ContadorRepository _repository;

  Incrementar(this._repository);

  Future<int> call() async {
    final nuevo = await _repository.leer() + 1;
    await _repository.guardar(nuevo);
    return nuevo;
  }
}
