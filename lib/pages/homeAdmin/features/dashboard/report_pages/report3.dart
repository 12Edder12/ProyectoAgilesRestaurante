import 'package:flutter/material.dart';

class Report3 extends StatelessWidget {
  const Report3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bebida Más Comprada'),
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