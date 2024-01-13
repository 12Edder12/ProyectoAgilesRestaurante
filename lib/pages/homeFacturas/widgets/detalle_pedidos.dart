import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DetallePedidoWidget extends StatelessWidget {
  final int numeroMesa;

  const DetallePedidoWidget({super.key, required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    String numeroFactura =
        uuid.v1().substring(0, 10); // Genera un UUID para el número de factura
    String fechaHora = DateFormat('dd-MM-yyyy').format(DateTime
        .now()); // Obtiene la fecha y hora actual en el formato dd-MM-yyyy // Obtiene la fecha y hora actual

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

          pedidos.sort((a, b) {
            if (a['nombre'].startsWith('Pizza') &&
                !b['nombre'].startsWith('Pizza')) {
              return -1;
            }
            if (!a['nombre'].startsWith('Pizza') &&
                b['nombre'].startsWith('Pizza')) {
              return 1;
            }
            return 0;
          });
          String nombreUsuario = datosUsuario['nom_user'];
          String apellidoUsuario = datosUsuario['ape_user'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Detalles del Pedido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Fecha: $fechaHora'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Número de factura: $numeroFactura'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Mesero: $nombreUsuario $apellidoUsuario'),
              ),
              const Divider(color: Colors.black), // Agrega una línea divisoria
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Productos:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    var pedido = pedidos[index];
                    double precioSinIva = 0.0;
                    double iva = 0.0;

                    if (!pedido['nombre'].startsWith('Pizza')) {
                      precioSinIva = double.parse(
                          (pedido['precioUnitario'] * 0.88).toStringAsFixed(2));
                      iva = double.parse(
                          (pedido['precioUnitario'] * 0.12).toStringAsFixed(2));
                    }

                    // Verifica si es el primer producto o si el producto anterior era de un tipo diferente
                    bool mostrarEncabezado = index == 0 ||
                        (pedido['nombre'].startsWith('Pizza') !=
                            pedidos[index - 1]['nombre'].startsWith('Pizza'));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mostrarEncabezado)
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 8.0),
                            decoration: BoxDecoration(
                              color: pedido['nombre'].startsWith('Pizza')
                                  ? Colors.yellow[200]
                                  : Colors.blue[200],
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(pedido['nombre'].startsWith('Pizza')
                                    ? Icons.local_pizza
                                    : Icons.local_drink),
                                const SizedBox(width: 8.0),
                                Text(
                                  pedido['nombre'].startsWith('Pizza')
                                      ? 'Pizzas'
                                      : 'Bebidas',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        Card(
                          color: pedido['nombre'].startsWith('Pizza')
                              ? Colors.yellow[50]
                              : Colors.blue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(pedido['nombre'],
                                style: const TextStyle(fontSize: 16)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cantidad: ${pedido['cantidad']}',
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    'Precio unitario: ${pedido['precioUnitario']}',
                                    style: const TextStyle(fontSize: 14)),
                                if (!pedido['nombre'].startsWith('Pizza')) ...[
                                  Text('Precio sin IVA: $precioSinIva',
                                      style: const TextStyle(fontSize: 14)),
                                  Text('IVA: $iva',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ],
                            ),
                            trailing: Text('Total: ${pedido['totalProducto']}',
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 20.0), // margen superior e inferior
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aquí va el código que se ejecutará cuando se presione el botón
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0, // sombra
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // padding
                    ),
                    icon: Icon(Icons.receipt_long), // icono
                    label: const Text('Facturar'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green),
                    Text(
                      'Total: $total',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
