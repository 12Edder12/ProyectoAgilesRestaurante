import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/constants/globals.dart';

class Buscador extends StatefulWidget {
  final Function(Map<String, dynamic> cliente)? onClienteSeleccionado;

  Buscador({this.onClienteSeleccionado});

  @override
  _BuscadorState createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  TextEditingController _cedulaController = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];
  Map<String, dynamic>? _clienteSeleccionado;

  @override
  void initState() {
    super.initState();
    _cedulaController.addListener(_buscarCliente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cedulaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingrese Cédula',
                suffixIcon: IconButton(
                  onPressed: _buscarCliente,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          const   SizedBox(height: 20),
            Expanded(
              child: _resultados.isNotEmpty
                  ? _buildDataTable()
                  :const  Center(
                      child: Text('Ingrese una cédula para buscar clientes.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buscarCliente() async {
    String cedula = _cedulaController.text.trim();

    if (cedula.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('clientes')
            .where('ced_cli', isGreaterThanOrEqualTo: cedula)
            .where('ced_cli', isLessThan: cedula + 'z')
            .get();

        List<Map<String, dynamic>> tempResultados = [];

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            String idFirebase = doc.id;
            tempResultados.add({
              'idFirebase': idFirebase,
              'ced_cli': doc['ced_cli'],
              'nom_cli': doc['nom_cli'],
              'cor_cli': doc['cor_cli'],
              'ape_cli': doc['ape_cli']
            });
          }
        } else {
        //  print('No se encontraron clientes con esa cédula.');
        }

        setState(() {
          _resultados = tempResultados;
        });
      } catch (e) {
       // print('Error al buscar clientes: $e');
      }
    } else {
      setState(() {
        _resultados.clear();
      });
    }
  }


  Widget _buildDataTable() {
    return DataTable(
      columns: const [
         DataColumn(label: Text('Cédula')),
         DataColumn(label: Text('Cliente')),
      ],
      rows: _resultados.map((cliente) {
        final isSelected = cliente ==
            _clienteSeleccionado; // Verificar si este cliente está seleccionado
        return DataRow(
          cells: [
            DataCell(Text(cliente['ced_cli'] ?? 'N/A')),
            DataCell(Text(
                '${cliente['nom_cli'] ?? 'N/A'} ${cliente['ape_cli'] ?? ''}')),
          ],
          selected: isSelected,
          // Establecer la fila como seleccionada si es el cliente seleccionado
          onSelectChanged: (isSelected) {
            if (isSelected == true) {
              setState(() {
                _clienteSeleccionado =
                    cliente; // Actualizar el cliente seleccionado
                _mostrarDetalleCliente(cliente);
              });
            } else {
              setState(() {
                _clienteSeleccionado = null; // Deseleccionar el cliente
              });
            }
          },
        );
      }).toList(),
    );
  }

  void _mostrarDetalleCliente(Map<String, dynamic> cliente) {
    if (widget.onClienteSeleccionado != null) {
      // Asigna los datos seleccionados a clienteSeleccionado en globals.dart
      clienteSeleccionado = {
        'idFirebase': cliente['idFirebase'],
        'ced_cli': cliente['ced_cli'],
        'nom_cli': cliente['nom_cli'],
        'cor_cli': cliente['cor_cli'],
        'ape_cli': cliente['ape_cli'],
        // Agrega otros datos según sea necesario
      };

      widget.onClienteSeleccionado!(
          cliente); // Llama al callback con la información del cliente
    }
  }
}
