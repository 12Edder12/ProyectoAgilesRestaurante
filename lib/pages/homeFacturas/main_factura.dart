
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_cliente.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_pedidos.dart';
import 'package:flutter/material.dart';

class main_factura extends StatelessWidget {
  const main_factura({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Facturacion con Efectivo'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Informacion Cliente'), // Texto para la primera pestaña
              Tab(text: 'Informacion Productos'), // Texto para la segunda pestaña
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Los widgets que se mostrarán en cada pestaña
            Center(child: DetalleCliente(numero: 1)),
            DetallePedidoWidget(numeroMesa: 4),
          ],
        ),
      ),
    );
  }
}