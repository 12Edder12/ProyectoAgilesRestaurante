
import 'package:bbb/pages/homeFacturas/widgets/detalle_productos.dart';
import 'package:flutter/material.dart';


class DetallePedidos extends StatefulWidget {
  final int numero;
  final Map<String, dynamic>? paymenItem;

  const DetallePedidos({Key? key, required this.numero, this.paymenItem})
      : super(key: key);

  @override
  _DetallePedidosState createState() => _DetallePedidosState();
}

class _DetallePedidosState extends State<DetallePedidos> {
  String? metodoPago;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pedidos ${widget.numero}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: metodoPago,
              hint: Text('Selecciona un método de pago'),
              items: <String>['Efectivo', 'Tarjeta de crédito']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  metodoPago = newValue;
                });
              },
            ),
            MesaDetalle(numeroMesa: widget.numero),
          ],
        ),
      ),
    );
  }
}