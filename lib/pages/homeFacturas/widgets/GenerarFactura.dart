import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/PdfGenerator.dart'; // Asegúrate de
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';

class BotonEnviarFactura extends StatelessWidget {
  int numeroMesa;
  int metodoPago; // Asegúrate de tener este campo definido

  BotonEnviarFactura(
      {super.key, required this.numeroMesa, required this.metodoPago});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // Para distribuir el espacio entre los botones
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
            // Centra el contenido
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra los elementos de la fila
              children: [
                Icon(Icons.person, color: Colors.grey), // Icono de persona
                SizedBox(width: 10), // Espacio horizontal
                Text('CLIENTE DE LA FACTURA',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        Text('Cedula/RUC: ${clienteSeleccionado?['ced_cli']}',
            style: const TextStyle(fontSize: 14)),
      const   SizedBox(height: 5), // Espacio vertical
        Text('Nombre: ${clienteSeleccionado?['nom_cli']}',
            style:const  TextStyle(fontSize: 14)),
       const  SizedBox(height: 5), // Espacio vertical
        Text('Apellido: ${clienteSeleccionado?['ape_cli']}',
            style:const  TextStyle(fontSize: 14)),
     const    SizedBox(height: 5), // Espacio vertical
        Text('Correo: ${clienteSeleccionado?['cor_cli']}',
            style: const TextStyle(fontSize: 14)),
        Padding(
          padding: const EdgeInsets.only(top: 20), // Espacio superior de 20 píxeles
          child: ElevatedButton(
            onPressed: () async {
              if (clienteSeleccionado != null) {
                // Invocar al método para generar el PDF
                datosFactura['num_mes'] = this.numeroMesa;
                Future<Map<String, dynamic>> productosDeLaMesa =
                    obtenerPedidosPorMesa(this.numeroMesa);
                Future<double> totalesDeLaMesa =
                    obtenerTotalPorMesa(this.numeroMesa);
                await PdfGenerator.generatePDF(
                    productosDeLaMesa, totalesDeLaMesa);
                _mostrarMensaje(context);
              } else {
                // Mostrar un mensaje de error si no hay cliente seleccionado
                _mostrarError(context);
              }
            },
            child: const Text('Confirmar Factura'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Color de fondo azul
              onPrimary: Colors.white, // Color de texto blanco
              padding:
               const    EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
            ),
          ),
        ),
      ],
    );
  }

// Función para mostrar un modal con un mensaje de cancelación
  void _mostrarCancelar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Acción Cancelada'),
          content: const Text('La acción ha sido cancelada.'),
          actions: <Widget>[
            TextButton(
              child:const  Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un modal con un mensaje de éxito
  void _mostrarMensaje(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Factura Generada y Enviada'),
          content:const  Text('La factura ha sido generada y enviada exitosamente.'),
          actions: <Widget>[
            TextButton(
              child:const  Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un modal con un mensaje de error
  void _mostrarError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Error'),
          content:const  Text(
              'Por favor, selecciona un cliente antes de enviar la factura.'),
          actions: <Widget>[
            TextButton(
              child:const  Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
