import 'package:bbb/services/auth/auth_service.dart';
import 'package:bbb/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeCocinero extends StatefulWidget {
  const HomeCocinero({super.key});

  @override
  State<HomeCocinero> createState() => _HomeCocineroState();
}

class _HomeCocineroState extends State<HomeCocinero> {
  Future<void> signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  // Variable para controlar si se muestra el cuadro de diálogo.
  bool showDialogBox = false;

  // Variable para almacenar los detalles del pedido seleccionado.
  Map<String, dynamic>? selectedPedido;

  // Función para mostrar el cuadro de diálogo con detalles del pedido.
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

  // ignore: use_build_context_synchronously
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text("Mesa: ${pedidoData['num_mesa']}", 
         style: const TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: SizedBox(
           height: 180, //  largo
          width: 400, // Ancho máximo
          child: ListView(
            shrinkWrap: true, // Ajusta el contenido al espacio necesario
            children: [
              const SizedBox(height: 10),
              const Text("Orden:", 
              style: TextStyle(fontWeight: FontWeight.bold)), 
               const SizedBox(height: 20),
              // Mostrar los nombres de los productos en lugar de los IDs.
              for (var i = 0; i < productoIDs.length; i++) ...[
                Text("${nombresProductos[i]}: ${pedidoData['detalle_pedido'][productoIDs[i]]['cantidad']}"),
               const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      
        actions: <Widget>[
          TextButton(
            child: const Text("Confirmar pedido"),
            onPressed: () async {
              if (selectedPedido != null) {
                // Mostrar un cuadro de diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmación"),
                      content: const Text("¿Estás seguro de realizar esta acción?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Sí"),
                          onPressed: () async {
                             marcarPedidoComoCompletado(selectedPedido?['id']); // Marcar el pedido como completado en Firebase
                            setState(() {
                              showDialogBox = false; // Cerrar el cuadro de diálogo.
                              selectedPedido = null; // Limpiar los detalles del pedido seleccionado.
                            });
                            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo de confirmación
                            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo original
                          },
                        ),
                          TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo de confirmación
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () {
              setState(() {
                showDialogBox = false; // Cerrar el cuadro de diálogo.
                selectedPedido = null; // Limpiar los detalles del pedido seleccionado.
              }); 
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo.
            },
          ),
        ],
      );
    },
  );
}

  // Función para marcar el pedido como completado en Firebase.
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
        title: const Text("Pedidos Pizza Guerrin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await signOut();
            },
          ),
        ],
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
    .where('completado', isEqualTo: false) // Filtra los pedidos no completados
    .orderBy('fecha', descending: false) // Ordena los pedidos por fecha ascendente (FIFO)
    .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  bool completado = data['completado'];
                   String pedidoId = document.id;
                  return InkWell(
                    onTap: () {
                      // Cuando se hace clic en el pedido, mostrar el cuadro de diálogo con detalles.
                      setState(() {
                        showDialogBox = true;
                        selectedPedido = data; // Almacena los detalles del pedido seleccionado.
                         selectedPedido?['id'] = document.id;
                      });
                      showPedidoDetailsDialog(data); // Muestra el cuadro de diálogo con detalles del pedido.
                    },
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          "Mesa: " + data['num_mesa'].toString() +
                          " - " + DateFormat('hh:mm a').format(data['fecha'].toDate()),
                            style: const TextStyle(fontSize: 18), 
                          ),
                        
                        trailing: completado
                            ? null // No mostrar el botón si el pedido está completado
                            : IconButton(
                                icon: const Icon(Icons.check_circle),
                                color: completado ? Colors.green : Colors.grey,
                                onPressed: () {
                                  // Marcar el pedido como completado en Firebase.
                                  marcarPedidoComoCompletado(pedidoId);
                                },
                              ),
                      ),
                    ),
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
