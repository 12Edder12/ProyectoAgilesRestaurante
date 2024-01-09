import 'package:flutter/material.dart';

class DetallePedidos extends StatelessWidget {
  final int numero;

  const DetallePedidos({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pedidos para la mesa $numero'),
      ),
      body: Center(
        child: Text('Aquí va el contenido para la mesa $numero'),
      ),
    );
  }
}