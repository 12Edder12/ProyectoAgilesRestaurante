import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report1.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report2.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report3.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report4.dart';

class DashBoardPage extends StatelessWidget {
  DashBoardPage({super.key});

  final buttonTitles = [
    'Pizzas Más Pedidas',
    'Bebidas Más Pedidas',
    'Ingresos',
    'Método de Pago',
  ];

  final buttonPages = [
    const Report1(),
    const Report2(),
    const Report3(),
    const Report4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.analytics_rounded, size: 100, color: Colors.orange),
            const Text(
              'Reportes Administrador',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: buttonTitles.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => buttonPages[index]),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assessment_rounded, size: 110), // Ajusta el tamaño del icono
                        Text(
                          buttonTitles[index],
                          style: const TextStyle(
                            fontSize: 14, // Ajusta el tamaño del texto
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
