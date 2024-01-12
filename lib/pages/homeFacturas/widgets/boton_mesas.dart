import 'package:bbb/constants/colors.dart';
import 'package:bbb/pages/homeFacturas/widgets/detalle_pedidos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  const Botones({super.key});

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // bordes redondeados
              ),
              elevation: 8, // sombra alrededor del card
              color: Colors.white, // color de fondo del card
              margin: EdgeInsets.all(10), // espacio alrededor del card
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: kPrimaryColor, width: 2), // borde azul
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // espacio interno del ListTile
                  leading: Icon(Icons.receipt,
                      color: Colors.black, size: 30), // icono de factura
                  title: Text(
                    "Mesa Nº ${data['num']}",
                    style: TextStyle(
                      color: Colors.black, // color del texto
                      fontWeight: FontWeight.bold, // grosor del texto
                      fontSize: 20, // tamaño del texto
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: Colors.black, size: 30), // icono de flecha
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetallePedidos(numero: data['num'])),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
