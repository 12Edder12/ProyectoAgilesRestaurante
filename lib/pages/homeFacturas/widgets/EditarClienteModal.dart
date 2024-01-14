import 'package:flutter/material.dart';
import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/services/userController.dart';

class EditarClienteModal extends StatefulWidget {
  final Map<String, dynamic>? cliente;

  const EditarClienteModal({Key? key, this.cliente}) : super(key: key);

  @override
  _EditarClienteModalState createState() => _EditarClienteModalState();
}

class _EditarClienteModalState extends State<EditarClienteModal> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _correoController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nombreController.text = widget.cliente!['nom_cli'] ?? '';
      _apellidoController.text = widget.cliente!['ape_cli'] ?? '';
      _correoController.text = widget.cliente!['cor_cli'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Editar Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cerrar el modal sin guardar cambios
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Guardar cambios y cerrar el modal
                    _guardarCambios();
                    Navigator.of(context).pop();
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _guardarCambios() async {
    final newUserData = {
      'nom_cli': _nombreController.text,
      'ape_cli': _apellidoController.text,
      'cor_cli': _correoController.text,
    };
    final clientService = ClientService();
    try {
      await clientService.updateClient(clienteSeleccionado?['idFirebase'], newUserData);
      print("Cliente actualizado");
    } catch (e) {
      print("Cliente fallo");
    }
  }
}
