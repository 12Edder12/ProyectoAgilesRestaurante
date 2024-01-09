import 'package:bbb/pages/homeFacturas/widgets/detalle_pedidos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference mesas = FirebaseFirestore.instance.collection('tables');

    return StreamBuilder<QuerySnapshot>(
      stream: mesas.where('pagado', isEqualTo: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo salió mal');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Cargando");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetallePedidos(numero: data['num'])),
                    );
                  },
                ),
                title: Text("Mesa Nº ${data['num']}"),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
