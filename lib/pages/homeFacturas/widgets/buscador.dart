// buscador.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuscadorClientes extends StatefulWidget {
  @override
  _BuscadorClientesState createState() => _BuscadorClientesState();
}

class _BuscadorClientesState extends State<BuscadorClientes> {
  final TextEditingController _controller = TextEditingController();
  String _cedula = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Ingrese Cédula'),
            onChanged: (value) {
              setState(() {
                _cedula = value.trim();
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _buscarCliente,
            child: Text('Buscar'),
          ),
          // Aquí puedes mostrar los resultados si lo deseas
        ],
      ),
    );
  }

  Future<void> _buscarCliente() async {
    if (_cedula.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('clientes')
            .where('ced_cli', isEqualTo: _cedula)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            print(doc.data()); // Imprime los datos del cliente encontrado
          }
        } else {
          print('No se encontraron clientes con esa cédula.');
        }
      } catch (e) {
        print('Error al buscar clientes: $e');
      }
    } else {
      print('Por favor, ingrese una cédula.');
    }
  }
}
