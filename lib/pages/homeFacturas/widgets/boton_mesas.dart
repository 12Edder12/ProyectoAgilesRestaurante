import 'dart:ffi';

import 'package:Pizzeria_Guerrin/constants/colors.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/main_factura.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/detalle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  const Botones({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference mesas = FirebaseFirestore.instance.collection('tables');

    return StreamBuilder<QuerySnapshot>(
      stream: mesas.where('pagado', isEqualTo: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo salió mal');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Cargando");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // bordes redondeados
              ),
              elevation: 8, // sombra alrededor del card
              color: Colors.white, // color de fondo del card
              margin: EdgeInsets.all(10), // espacio alrededor del card
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: kPrimaryColor, width: 2), // borde azul
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // espacio interno del ListTile
                  leading: const Icon(Icons.receipt,
                      color: Colors.black, size: 30), // icono de factura
                  title: Text(
                    "Mesa Nº ${data['num']}",
                    style: const TextStyle(
                      color: Colors.black, // color del texto
                      fontWeight: FontWeight.bold, // grosor del texto
                      fontSize: 20, // tamaño del texto
                    ),
                  ),
                  subtitle: FutureBuilder<double>(
                    future: obtenerTotalPorMesa(data['num']),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Cargando total...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('Total: ${snapshot.data}');
                      }
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.black, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Selecciona un método de pago'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Text("Efectivo"),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const main_factura()),
                                      );
                                    },
                                  ),
                                  Padding(padding: EdgeInsets.all(8.0)),
                                  GestureDetector(
                                    child: Text("Stripe"),
                                    onTap: () {
                                      /* 
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PagoStripe()),
                                      );*/
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

Future<double> obtenerTotalPorMesa(int numeroMesa) async {
  var pedidosRef = FirebaseFirestore.instance.collection('pedidos');
  var productosRef = FirebaseFirestore.instance.collection('productos');

  Map<String, dynamic> resultado = {
    'productos': [],
    'total': 0.0,
  };

  try {
    var pedidos = await pedidosRef
        .where('num_mesa', isEqualTo: numeroMesa)
        .where('pagado', isEqualTo: false)
        .get();

    for (var pedido in pedidos.docs) {
      var detallePedido = pedido.data()['detalle_pedido'];

      for (String idProducto in detallePedido.keys) {
        var cantidad = detallePedido[idProducto]['cantidad'];

        var producto = await productosRef.doc(idProducto).get();
        var precio = producto.data()?['precio'];

        double totalProducto = precio * cantidad;
        resultado['total'] += totalProducto;
      }
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }

  return double.parse(resultado['total'].toStringAsFixed(2));
}
