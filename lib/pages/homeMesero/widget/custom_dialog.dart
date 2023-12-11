import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bbb/models/pedido.dart';
import 'package:bbb/constants/globals.dart' as globals;
import 'package:bbb/constants/colors.dart';

class CustomDialog extends StatefulWidget {
  final List<Pedido> pedidos;

  CustomDialog({required this.pedidos});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pedido Nº ${DateTime.now().millisecondsSinceEpoch}',
                      style: const TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                backgroundColor:
                    kSecondaryColor, // Cambia esto al color que desees
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Mesa Nº ${globals.mesaOrden.toString()}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]..addAll(
                        widget.pedidos.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Pedido pedido = entry.value;
                          return Dismissible(
                            // Cada Dismissible debe contener una clave única. En este caso, usamos un valor entero
                            // que representa el índice actual.
                            key: Key(pedido.hashCode.toString()),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              setState(() {
                                widget.pedidos.removeAt(idx);
                                globals.orderCount--;
                              });
                            },
                            // Muestra un fondo rojo mientras el elemento se desliza.
                            background: Container(color: kPrimaryColor),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  'Pizza: ${pedido.food.name}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  'Cantidad: ${pedido.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    final controller = TextEditingController();
                                    String errorMessage = '';

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Editar cantidad'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  TextField(
                                                    controller: controller,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                  ),
                                                  Text(
                                                    errorMessage,
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child:
                                                      const Text('Confirmar'),
                                                  onPressed: () {
                                                    // Verifica si el campo de texto está vacío
                                                    if (controller
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        errorMessage =
                                                            "Por favor, ingrese una cantidad";
                                                      });
                                                    } else {
                                                      int newQuantity =
                                                          int.parse(
                                                              controller.text);
                                                      // Verifica si la nueva cantidad es mayor que 10 o menor que 1
                                                      if (newQuantity > 10) {
                                                        setState(() {
                                                          errorMessage =
                                                              "La cantidad no puede ser mayor que 10";
                                                        });
                                                      } else if (newQuantity <
                                                          1) {
                                                        setState(() {
                                                          errorMessage =
                                                              "La cantidad no puede ser menor que 1";
                                                        });
                                                      } else {
                                                        pedido.quantity =
                                                            newQuantity;
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor, // color del fondo
                    foregroundColor: Colors.white, // color del texto
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // bordes redondeados
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10), // padding
                  ),
                  /*    ;*/
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, color: black),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: const Text('Confirmar Pedido',
                            style: TextStyle(fontSize: 20, color: black)),
                      ),
                    ],
                  ),
                  /* onPressed: () {
                  for (Pedido pedido in globals.pedidos) {
                    print(
                        'Pedido: ${pedido.food.name} - Cantidad: ${pedido.quantity}');
                  }
                },*/
                  onPressed: () async {
                    try {
                      // Crear un nuevo documento en la colección 'pedidos'
                      DocumentReference pedidoRef =
                          await _firestore.collection('pedidos').add({
                        'num_mesa': globals
                            .mesaOrden, // Puedes cambiar esto según el número de mesa
                        'detalle_pedido': {
                          for (Pedido pedido in widget.pedidos)
                            pedido.food.id: {
                              'cantidad': pedido.quantity,
                            },
                        },
                      });

                      // Muestra un SnackBar con un mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Pedido confirmado con ID: ${pedidoRef.id}'),
                          backgroundColor:
                              Colors.green, // color de fondo verde para éxito
                        ),
                      );

                      widget.pedidos.clear();
                      globals.orderCount = 0;

                      Navigator.of(context).pop();
                    } catch (e) {
                      // Muestra un SnackBar con un mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Algo salió mal al subir el pedido a Firebase'),
                          backgroundColor:
                              Colors.red, // color de fondo rojo para error
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
