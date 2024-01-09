import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  final VoidCallback onPressed;

  Botones({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(7, (index) {
        return ElevatedButton(
          onPressed: onPressed,
          child: Text('Botón ${index + 1}'),
        );
      }),
    );
  }
}