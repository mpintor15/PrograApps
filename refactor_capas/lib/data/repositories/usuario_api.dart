import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  static const _url = 'https://jsonplaceholder.typicode.com/users';

  final http.Client _cliente;

  UsuarioApi({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  @override
  Future<List<Usuario>> obtener() async {
    final respuesta = await _cliente.get(Uri.parse(_url));
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode} al obtener usuarios');
    }
    final lista = jsonDecode(respuesta.body) as List;
    return lista
        .cast<Map<String, dynamic>>()
        .map((json) => Usuario(
              id: json['id'] as int,
              nombre: json['name'] as String,
              email: json['email'] as String,
            ))
        .toList();
  }
}
