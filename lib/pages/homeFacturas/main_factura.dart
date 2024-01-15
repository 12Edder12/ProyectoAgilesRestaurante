import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_cliente.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_pedidos.dart';
import 'package:flutter/material.dart';

class main_factura extends StatefulWidget {
  final int numeroMesa;
  final int metodoPago;

  const main_factura({Key? key, required this.numeroMesa, required this.metodoPago}) : super(key: key);

  @override
  _main_facturaState createState() => _main_facturaState();
}

class _main_facturaState extends State<main_factura> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Facturacion Mesa Nº ${widget.numeroMesa}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Información Cliente'), // Texto para la primera pestaña
              Tab(text: 'Información Productos'), // Texto para la segunda pestaña
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Los widgets que se mostrarán en cada pestaña
            DetalleCliente(numero: widget.numeroMesa),
            DetallePedidoWidget(numeroMesa: widget.numeroMesa, parametro: widget.metodoPago, mounted: this.mounted),
          ],
        ),
      ),
    );
  }
}