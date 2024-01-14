import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/PdfGenerator.dart'; // Asegúrate de importar la ubicación correcta de tu archivo PdfGenerator.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/detalles_productos.dart';

class BotonEnviarFactura extends StatelessWidget {
  int numeroMesa; // Asegúrate de tener este campo definido

  BotonEnviarFactura({required this.numeroMesa});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // Para distribuir el espacio entre los botones
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('      CLIENTE DE LA FACTURA'),
              Text('Cedula/RUC: ${clienteSeleccionado?['ced_cli']}'),
              Text('Nombre: ${clienteSeleccionado?['nom_cli']}'),
              Text('Apellido: ${clienteSeleccionado?['ape_cli']}'),
              Text('Correo: ${clienteSeleccionado?['cor_cli']}'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (clienteSeleccionado != null) {
              // Invocar al método para generar el PDF
              Future<Map<String, dynamic>> productosDeLaMesa = obtenerPedidosPorMesa(this.numeroMesa);
              await PdfGenerator.generatePDF(productosDeLaMesa);
              print(clienteSeleccionado);
              // Mostrar un modal con un mensaje
              _mostrarMensaje(context);
            } else {
              // Mostrar un mensaje de error si no hay cliente seleccionado
              _mostrarError(context);
            }
          },
          child: Text('Confirmar Factura'),
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
          title: Text('Acción Cancelada'),
          content: Text('La acción ha sido cancelada.'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
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
          title: Text('Factura Generada y Enviada'),
          content: Text('La factura ha sido generada y enviada exitosamente.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
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
          title: Text('Error'),
          content: Text(
              'Por favor, selecciona un cliente antes de enviar la factura.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
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
