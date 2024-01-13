import 'package:flutter/material.dart';

class BotonEnviarFactura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _mostrarMensaje(context); // Llamamos a la función para mostrar el modal
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
          title: Text('Factura Enviada'),
          content: Text('La factura ha sido enviada exitosamente.'),
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
