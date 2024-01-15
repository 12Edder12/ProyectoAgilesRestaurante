import 'package:Pizzeria_Guerrin/pages/homeCocinero/widget/pedido_card.dart';
import 'package:Pizzeria_Guerrin/pages/homeCocinero/widget/sign_out_button.dart';
import 'package:Pizzeria_Guerrin/services/auth/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCocinero extends StatefulWidget {
  const HomeCocinero({super.key});

  @override
  State<HomeCocinero> createState() => _HomeCocineroState();
}

class _HomeCocineroState extends State<HomeCocinero> {
  Map<String, dynamic>? selectedPedido;

// Variable para controlar si se muestra el cuadro de diálogo.
  bool showDialogBox = false;

  // Variable para almacenar los detalles del pedido seleccionado.
  Map<String, dynamic>? a;


void showPedidoDetailsDialog(Map<String, dynamic> pedidoData) async {
    // Obtener una lista de IDs de productos del pedido.
    List<String> productoIDs = pedidoData['detalle_pedido'].keys.toList();

    // Obtener los nombres de los productos correspondientes a los IDs desde la tabla de productos.
    List<String> nombresProductos = [];

    for (String productoID in productoIDs) {
      DocumentSnapshot productoSnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .doc(productoID)
          .get();
      if (productoSnapshot.exists) {
        String nombreProducto = productoSnapshot['nombre']; // Reemplaza 'nombre' con el campo correcto en tu tabla de productos.
        nombresProductos.add(nombreProducto);
      }
    }

    String mensajeNotificacion = "Mesa: ${pedidoData['num_mesa']}\n";
    for (var productoID in productoIDs) {
      DocumentSnapshot productoSnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .doc(productoID)
          .get();
      if (productoSnapshot.exists) {
        String nombreProducto = productoSnapshot['nombre'];
        int cantidad = pedidoData['detalle_pedido'][productoID]['cantidad'];
        mensajeNotificacion += "$nombreProducto: $cantidad\n";
      }
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.restaurant), // Icono de mesa
              const SizedBox(width: 10),
              Text("Mesa: ${pedidoData['num_mesa']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Arial')),
            ],
          ),
          backgroundColor:
              const Color(0xFFE0E0E0), // Cambiado a un color gris claro
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: Colors.black, width: 3),
          ),
          content: SizedBox(
            height: 180, //  largo
            width: 400, // Ancho máximo
            child: ListView(
              shrinkWrap: true, // Ajusta el contenido al espacio necesario
              children: [
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                const Text("Orden:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Arial')),
                const SizedBox(height: 20),
                // Mostrar los nombres de los productos en lugar de los IDs.
                for (var i = 0; i < productoIDs.length; i++) ...[
                  Row(
                    children: [
                      const Icon(Icons.fastfood), // Icono de comida
                      const SizedBox(width: 10),
                      Text(
                          "${nombresProductos[i]}: ${pedidoData['detalle_pedido'][productoIDs[i]]['cantidad']}",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),

          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.check, color: Colors.green),
              label: const Text(
                "Confirmar pedido",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              onPressed: () async {
                if (selectedPedido != null) {
                  // Mostrar un cuadro de diálogo de confirmación
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Confirmación",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24),
                        ),
                        backgroundColor: const Color(0xFFE0E0E0),
                        content: const Text(
                            "¿Estás seguro de realizar esta acción?"),
                        actions: <Widget>[
                          TextButton.icon(
                            icon: const Icon(Icons.check, color: Colors.green),
                            label: const Text(
                              "Sí",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            onPressed: () async {
                              marcarPedidoComoCompletado(selectedPedido?[
                                  'id']); // Marcar el pedido como completado en Firebase
                              setState(() {
                               // print('Selected Pedido: $selectedPedido');
                                showDialogBox =
                                    false; // Cerrar el cuadro de diálogo.
                                a = selectedPedido;
                                selectedPedido =
                                    null; // Limpiar los detalles del pedido seleccionado.
                              });

                              Navigator.of(context)
                                  .pop(); // Cerrar el cuadro de diálogo de confirmación
                              Navigator.of(context)
                                  .pop(); // Cerrar el cuadro de diálogo original

                              await enviarNotificacion(
                                  "Pedido Lista para se entregado",
                                  mensajeNotificacion);
                            },
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text(
                              "No",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cerrar el cuadro de diálogo de confirmación
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text(
                "Cerrar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              onPressed: () {
                setState(() {
                  showDialogBox = false; // Cerrar el cuadro de diálogo.
                  selectedPedido =
                      null; // Limpiar los detalles del pedido seleccionado.
                });
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo.
              },
            ),
          ],
        );
      },
    );
}

  void marcarPedidoComoCompletado(String pedidoId) {
    FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedidoId)
        .update({'completado': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pedidos Pizza Guerrin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFEB8F1E),
        actions: const [ AuthSignOutButton()],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              "lib/img/xd.jpeg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('pedidos')
                .where('completado', isEqualTo: false)
                .orderBy('fecha', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return PedidoTile(
                    pedidoData: data,
                    onTap: () {
                      setState(() {
                        selectedPedido = data;
                        selectedPedido?['id'] = document.id;
                      });
                      showPedidoDetailsDialog(data);
                    },
                    onCompleted: () {
                      marcarPedidoComoCompletado(document.id);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
