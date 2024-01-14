import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/GenerarFactura.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/NewClient.dart';
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
  Map<String, dynamic>? _clienteSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 5,
                child: Buscador(
                  onClienteSeleccionado: (cliente) {
                    setState(() {
                      _clienteSeleccionado = cliente;
                    });
                    print(
                        'Cliente seleccionado: ${cliente['nom_cli']} ${cliente['ape_cli']}');
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // Alineación para distribuir el espacio entre los widgets
              children: [
                Expanded(
                  child: (NuevoClienteModal()),
                ),
                SizedBox(width: 10), // Espaciador opcional entre botones
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_clienteSeleccionado != null) {
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
                                    children: [
                                      // Contenido del botón para enviar factura
                                      BotonEnviarFactura(
                                          clienteSeleccionado:
                                              _clienteSeleccionado),

                                      // Espaciador
                                      SizedBox(height: 20),

                                      // Botón para cancelar
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cierra el Dialog
                                        },
                                        child: Text('Cancelar'),
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
                      }
                    },
                    child: Text('Enviar Factura'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
