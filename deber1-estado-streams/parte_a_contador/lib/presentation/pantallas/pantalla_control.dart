import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  const PantallaControl({
    super.key,
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
  });

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador = widget.valorInicial;

  Future<void> _sumar() async {
    final valor = await widget.incrementar();
    if (mounted) setState(() => _contador = valor);
  }

  Future<void> _restar() async {
    final valor = await widget.decrementar();
    if (mounted) setState(() => _contador = valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_contador',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _sumar, child: const Text('+1')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _restar, child: const Text('-1')),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(_contador),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
