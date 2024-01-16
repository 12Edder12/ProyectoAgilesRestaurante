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
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _correoController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _cedulaController.text = widget.cliente!['ced_cli'] ?? '';
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
           const  Text(
              'Editar Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
         const    SizedBox(height: 20),
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(labelText: 'Cedula'),
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration:const  InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
           const  SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cerrar el modal sin guardar cambios
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validar datos antes de guardar
                    if (_validarDatos()) {
                      // Guardar cambios y cerrar el modal
                      _guardarCambios();
                      Navigator.of(context).pop();
                    } else {
                      // Mostrar mensaje de error o hacer algo en caso de datos no válidos
                    //  print('Datos no válidos');
                    }
                  },
                  child:const  Text('Guardar'),
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
      'ced_cli': _cedulaController.text,
      'nom_cli': _nombreController.text,
      'ape_cli': _apellidoController.text,
      'cor_cli': _correoController.text,
    };
    final clientService = ClientService();
    try {
      await clientService.updateClient(clienteSeleccionado?['idFirebase'], newUserData);
   //   print("Cliente actualizado");
    } catch (e) {
   //   print("Cliente fallo");
    }
  }

  bool _validarDatos() {
    // Validar la cédula ecuatoriana
    String cedula = _cedulaController.text;
    if (!validarCedulaEcuatoriana(cedula)) {
      _mostrarMensajeError('La cédula ingresada no es válida.');
    //  print(cedula);
      return false;
    }

    // Validar el correo electrónico
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(_correoController.text)) {
      _mostrarMensajeError('El correo electrónico no tiene un formato válido.');
      return false;
    }

    // Validar que los otros campos no estén vacíos
    if (_nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _correoController.text.isEmpty) {
      _mostrarMensajeError('Todos los campos son obligatorios.');
      return false;
    }
    return true;
  }

  void _mostrarMensajeError(String mensaje) {
    // Muestra un modal temporal con el mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 3),
      ),
    );
  }


  bool validarCedulaEcuatoriana(String cedula) {
    // Verificar longitud
    if (cedula.length != 10) {
      return false;
    }

    // Verificar formato numérico
    if (!RegExp(r'^[0-9]+$').hasMatch(cedula)) {
      return false;
    }

    // Verificar provincia
    int provincia = int.parse(cedula.substring(0, 2));
    if (provincia < 1 || provincia > 24) {
      return false;
    }

    // Verificar tercer dígito
    int tercerDigito = int.parse(cedula[2]);
    if (tercerDigito < 0 || tercerDigito > 6) {
      return false;
    }

    // Algoritmo de verificación del último dígito
    List<int> coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    int suma = 0;

    for (int i = 0; i < 9; i++) {
      int digito = int.parse(cedula[i]);
      int producto = digito * coeficientes[i];

      if (producto > 9) {
        producto -= 9;
      }

      suma += producto;
    }

    int resultado = 10 - (suma % 10);
    if (resultado == 10) {
      resultado = 0;
    }

    int ultimoDigito = int.parse(cedula[9]);
    return resultado == ultimoDigito;
  }
}
