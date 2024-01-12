import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report1.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report2.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report3.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report4.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/dashboard/report_pages/report5.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatelessWidget {
  DashBoardPage({super.key});

  final buttonTitles = [
    'Pizzas Más Vendidas',
    'Día que Más se Vende',
    'Bebida Más Comprada',
    'Ingresos',
    'Hora en que se Vende Más el Producto'
  ];
  final buttonPages = [
    const Report1(),
    const Report2(),
    const Report3(),
    const Report4(),
    const Report5()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.construction, size: 100, color: Colors.orange),
            const Text(
              'Loro bebe estuvo aqui',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(buttonTitles.length, (index) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => buttonPages[index]),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const  RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Esto hace que el botón sea cuadrado
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                       const   Icon( Icons.abc, size: 20), // Cambia el icono aquí
                          Text(buttonTitles[index]),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}