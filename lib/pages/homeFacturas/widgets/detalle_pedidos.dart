
import 'package:flutter/material.dart';


class DetallePedidos extends StatelessWidget {
  final int numero;
  final Map<String, dynamic>? paymenItem;

  const DetallePedidos({Key? key, required this.numero, this.paymenItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pedidos para la mesa $numero'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Aquí va el contenido para la mesa $numero'),
            ElevatedButton(onPressed: () {  }, child: null,
              
            ),
          ],
        ),
      ),
    );
  }





}
