// En pedido_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bbb/constants/colors.dart';

class PedidoTile extends StatelessWidget {
  final Map<String, dynamic> pedidoData;
  final VoidCallback onTap;
  final VoidCallback onCompleted;

  const PedidoTile({
    super.key,
    required this.pedidoData,
    required this.onTap,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    bool completado = pedidoData['completado'] as bool;
    return InkWell(
      onTap: onTap,
      child: Card(
        color: kPrimaryColor,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            "Mesa: ${pedidoData['num_mesa']} - ${DateFormat('hh:mm a').format(pedidoData['fecha'].toDate())}",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          trailing: completado ? null : IconButton(
            icon: const Icon(Icons.check_circle),
            color: Colors.white,
            onPressed: onCompleted,
          ),
        ),
      ),
    );
  }
}
