
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/stripe_service.dart';
import 'package:flutter/material.dart';

class MesaDetalle extends StatefulWidget {
  final int numeroMesa;

  const MesaDetalle({required this.numeroMesa});

  @override
  _MesaDetalleState createState() => _MesaDetalleState();
}

class _MesaDetalleState extends State<MesaDetalle> {
  String? metodoPago;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerPedidosPorMesa(widget.numeroMesa),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var pedidos = snapshot.data!['productos'];
          var total = snapshot.data!['total'];

          return Column(
            children: [
              Text('Total: $total'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  var pedido = pedidos[index];
                  return ListTile(
                    title: Text(pedido['nombre']),
                    subtitle: Text('Cantidad: ${pedido['cantidad']}'),
                    trailing: Text('Total: ${pedido['totalProducto']}'),
                  );
                },
              ),
              DropdownButton<String>(
                value: metodoPago,
                hint: const Text('Selecciona un método de pago'),
                items: <String>['Efectivo', 'Tarjeta de crédito']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  setState(() {
                    metodoPago = newValue;
                  });
                  if (newValue == 'Tarjeta de crédito') {
                    var items = pedidos.map((pedido) {
                      return {
                        "productName": pedido['nombre'],
                        "productPrice": pedido['precio'],
                        "qty": pedido['cantidad']
                      };
                    }).toList();
                    var stripeService = StripeService();
                    await stripeService.stripePaymentCheckout(
                        items, total, context, mounted, onSucces: () {
                      print("Pago exitoso");
                    }, onCancel: () {
                      print("Pago cancelado");
                    }, onError: (e) {
                      print("Ocurrió un error" + e.toString());
                    });
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }
}

