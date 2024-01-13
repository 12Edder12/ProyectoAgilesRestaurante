import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_cliente.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_pedidos.dart';
import 'package:flutter/material.dart';

class main_factura extends StatelessWidget {
  final int numeroMesa;

  const main_factura({Key? key, required this.numeroMesa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Facturacion Mesa Nº $numeroMesa'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Informacion Cliente'), // Texto para la primera pestaña
              Tab(text: 'Informacion Productos'), // Texto para la segunda pestaña
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Los widgets que se mostrarán en cada pestaña
            DetalleCliente(numero: 1),
            DetallePedidoWidget(numeroMesa: numeroMesa),
          ],
        ),
      ),
    );
  }
}