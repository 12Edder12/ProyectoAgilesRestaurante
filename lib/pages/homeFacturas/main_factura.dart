
import 'package:flutter/material.dart';

class main_factura extends StatelessWidget {
  const main_factura({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mi Pantalla con Pestañas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Detalles Cliente'), // Texto para la primera pestaña
              Tab(text: 'Detalles Pedidos'), // Texto para la segunda pestaña
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Los widgets que se mostrarán en cada pestaña
            Center(child: Text('Contenido de la pestaña Detalles Cliente')),
            Center(child: Text('Contenido de la pestaña Detalles Pedidos')),
          ],
        ),
      ),
    );
  }
}