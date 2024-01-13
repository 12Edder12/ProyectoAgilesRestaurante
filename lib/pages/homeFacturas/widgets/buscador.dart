import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Buscador extends StatefulWidget {
  @override
  _ClienteDetalleState createState() => _ClienteDetalleState();
}

class _ClienteDetalleState extends State<Buscador> {
  String _cedula = '';
  List<Map<String, dynamic>> _resultados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _cedula = value.trim();
                });
              },
              decoration: InputDecoration(
                labelText: 'Ingrese Cédula',
                suffixIcon: IconButton(
                  onPressed: _buscarCliente,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _resultados.isNotEmpty
                  ? DataTable(
                columns: [
                  DataColumn(label: Text('Cédula')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Correo')),
                ],
                rows: _resultados.map((cliente) {
                  return DataRow(cells: [
                    DataCell(Text(cliente['ced_cli'] ?? 'N/A')),
                    DataCell(Text(cliente['nom_cli'] ?? 'N/A')),
                    DataCell(Text(cliente['cor_cli'] ?? 'N/A')),
                  ]);
                }).toList(),
              )
                  : Center(
                child: Text('Ingrese una cédula para buscar clientes.'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buscarCliente() async {
    if (_cedula.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('clientes')
            .where('ced_cli', isEqualTo: _cedula)
            .get();

        List<Map<String, dynamic>> tempResultados = [];

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            tempResultados.add({
              'ced_cli': doc['ced_cli'],
              'nom_cli': doc['nom_cli'],
              'cor_cli': doc['cor_cli'],
            });
          }
        } else {
          print('No se encontraron clientes con esa cédula.');
        }

        setState(() {
          _resultados = tempResultados;
        });
      } catch (e) {
        print('Error al buscar clientes: $e');
      }
    } else {
      print('Por favor, ingrese una cédula.');
    }
  }
}
