import 'package:flutter/material.dart';

class Report5 extends StatelessWidget {
  const Report5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hora en que se Vende Más el Producto'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Volver'),
        ),
      ),
    );
  }
}