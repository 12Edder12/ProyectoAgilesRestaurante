import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';
import 'package:flutter/material.dart';

class DetallePedidoWidget extends StatelessWidget {
  final int numeroMesa;

  const DetallePedidoWidget({super.key, required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerPedidosPorMesa(numeroMesa),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ocurrió un error: ${snapshot.error}');
        } else {
          var pedidos = snapshot.data!['productos'];
          var total = snapshot.data!['total'];

          return Column(
            children: [
              Text('Detalles del Pedido para la Mesa: $numeroMesa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Fecha y hora: ${snapshot.data!['fechaHora']}'),
              Text('Número de factura: ${snapshot.data!['numeroFactura']}'),
              Text('Camarero: ${snapshot.data!['camarero']}'),
              SizedBox(
                  height:
                      20), // Espacio entre los detalles de la factura y la lista de productos
              Text('Productos:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    var pedido = pedidos[index];
                    return Card(
                      child: ListTile(
                        title: Text(pedido['nombre'],
                            style: TextStyle(fontSize: 16)),
                        subtitle: Text('Cantidad: ${pedido['cantidad']}',
                            style: TextStyle(fontSize: 14)),
                        trailing: Text('Total: ${pedido['totalProducto']}',
                            style: TextStyle(fontSize: 14)),
                      ),
                    );
                  },
                ),
              ),
              Text('Impuestos: ${snapshot.data!['impuestos']}'),
              Text('Propina: ${snapshot.data!['propina']}'),
              Text('Total: $total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          );
        }
      },
    );
  }
}
