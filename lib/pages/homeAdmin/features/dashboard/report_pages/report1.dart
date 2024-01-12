import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class Report1 extends StatelessWidget {
  const Report1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas Más Vendidas'),
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