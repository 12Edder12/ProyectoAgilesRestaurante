import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/GenerarFactura.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/buscador.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle_productos.dart';
import 'package:flutter/material.dart';

class DetalleCliente extends StatefulWidget {
  final int numero;
  final Map<String, dynamic>? paymenItem;

  const DetalleCliente({Key? key, required this.numero, this.paymenItem})
      : super(key: key);

  @override
  _DetalleClienteState createState() => _DetalleClienteState();
}

class _DetalleClienteState extends State<DetalleCliente> {
  String? metodoPago;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(flex: 5, child: Buscador()),
            BotonEnviarFactura(),
          ],
        ),
      ),
    );
  }
}
