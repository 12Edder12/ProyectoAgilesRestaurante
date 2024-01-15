import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/stripe_service.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/GenerarFactura.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final ValueNotifier<bool> _pagoExitoso = ValueNotifier<bool>(false);

class DetallePedidoWidget extends StatelessWidget {
  final int numeroMesa;
  final int parametro;
  final bool mounted;
  const DetallePedidoWidget(
      {super.key,
      required this.numeroMesa,
      required this.parametro,
      required this.mounted});

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    numeroFactura =
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
              if (parametro == 1) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder<String>(
                    valueListenable: idStripe,
                    builder: (context, value, child) {
                      return Text('Id Stripe: $value');
                    },
                  ),
                ),
              ],
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
                          (pedido['precio'] * 0.88).toStringAsFixed(2));
                      iva = double.parse(
                          (pedido['precio'] * 0.12).toStringAsFixed(2));
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
                                Text('Precio unitario: ${pedido['precio']}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //stripe
                  if (parametro == 1) ...[
                    ValueListenableBuilder<bool>(
                      valueListenable: _pagoExitoso,
                      builder: (context, value, child) {
                        return ElevatedButton.icon(
                          onPressed: value
                              ? null
                              : () async {
                                  var items = pedidos.map((pedido) {
                                    return {
                                      "productName": pedido['nombre'],
                                      "productPrice": pedido['precio'],
                                      "qty":
                                          (pedido['cantidad'] as double).toInt()
                                    };
                                  }).toList();
                                  var stripeService = StripeService();
                                  await stripeService.stripePaymentCheckout(
                                      items, total, context, mounted,
                                      onSucces: () {
                                    _pagoExitoso.value = true;
                                  });
                                },
                          icon: const Icon(Icons.payment),
                          label: const Text('Stripe'),
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _pagoExitoso,
                      builder: (context, value, child) {
                        return ElevatedButton.icon(
                          onPressed: value
                              ? () {
                                  _pagoExitoso.value = false;
                                  if (clienteSeleccionado != null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  // Contenido del botón para enviar factura
                                                  BotonEnviarFactura(
                                                      numeroMesa:
                                                          this.numeroMesa,
                                                      metodoPago: 0),
                                                  // Espaciador
                                                  SizedBox(height: 20),

                                                  // Botón para cancelar
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Cierra el Dialog
                                                    },
                                                    child:
                                                        const Text('Cancelar'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    // Muestra un SnackBar indicando que no hay un cliente seleccionado
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'No hay cliente seleccionado para la Factura.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }

                                  //solo para test, reesete el id stripe
                                  //idStripe.value = '';
                                }
                              : null,
                          icon: Icon(Icons.receipt_long),
                          label: Text('Facturar'),
                        );
                      },
                    ),
                  ],
                  //efectivo
                  if (parametro == 0) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        if (clienteSeleccionado != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // Contenido del botón para enviar factura
                                        BotonEnviarFactura(
                                            numeroMesa: this.numeroMesa,
                                            metodoPago: 0),
                                        // Espaciador
                                        SizedBox(height: 20),

                                        // Botón para cancelar
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Cierra el Dialog
                                          },
                                          child: const Text('Cancelar'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          // Muestra un SnackBar indicando que no hay un cliente seleccionado
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'No hay cliente seleccionado para la Factura.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5.0, // sombra
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // padding
                      ),
                      icon: const Icon(Icons.receipt_long), // icono
                      label: const Text('Facturar'),
                    ),
                  ],
                ],
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
