import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/PdfGenerator.dart';  // Asegúrate de importar la ubicación correcta de tu archivo PdfGenerator.dart

class BotonEnviarFactura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Invocar al método para generar el PDF
        await PdfGenerator.generatePDF();

        // Mostrar un modal con un mensaje
        _mostrarMensaje(context);
      },
      child: Text('Enviar Factura'),
    );
  }

  // Función para mostrar un modal con un mensaje
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
                Navigator.of(context).pop(); // Cerrar el modal
              },
            ),
          ],
        );
      },
    );
  }
}
