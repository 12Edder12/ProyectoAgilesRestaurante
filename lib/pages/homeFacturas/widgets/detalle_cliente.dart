import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/EditarClienteModal.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/GenerarFactura.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/NewClient.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/buscador.dart';
import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/constants/globals.dart';

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
            Flexible(
                flex: 5,
                child: Buscador(
                  onClienteSeleccionado: (cliente) {
                    setState(() {
                      clienteSeleccionado = cliente;
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
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (clienteSeleccionado != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditarClienteModal(cliente: clienteSeleccionado);
                          },
                        );
                      }
                    },
                    child: Text('Editar Cliente'),
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
