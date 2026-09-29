import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContadorCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ContadorCubit, int>(
              builder: (context, contador) => Text(
                '$contador',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cubit.incrementar,
              child: const Text('+1'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: cubit.decrementar,
              child: const Text('-1'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
