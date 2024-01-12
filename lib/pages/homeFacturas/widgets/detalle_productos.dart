

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MesaDetalle extends StatelessWidget {
  final int numeroMesa;

  MesaDetalle({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerPedidosPorMesa(numeroMesa),
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
            ],
          );
        }
      },
    );
  }
}


Future<Map<String, dynamic>> obtenerPedidosPorMesa(int numeroMesa) async {
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
        var nombreProducto = producto.data()?['nombre'];

        double totalProducto = precio * cantidad;
        resultado['total'] += totalProducto;

        resultado['productos'].add({
          'nombre': nombreProducto,
          'cantidad': cantidad,
          'precio': precio,
          'totalProducto': totalProducto,
        });
      }
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }

  return resultado;
}