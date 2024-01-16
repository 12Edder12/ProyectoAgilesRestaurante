import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NuevoClienteModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _mostrarFormularioNuevoCliente(context);
      },
      child: const Text('Añadir Cliente'),
    );
  }

  void _mostrarFormularioNuevoCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Añadir Cliente'),
              content: _formularioNuevoCliente(context),
            ),
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _formularioNuevoCliente(BuildContext context) {
    String cedula = '';
    String nombre = '';
    String apellido = '';
    String correo = '';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Cédula'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese la cédula';
              }
              return null;
            },
            onSaved: (value) => cedula = value!,
          ),
          TextFormField(
            decoration:const  InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese el Nombre';
              }
              return null;
            },
            onSaved: (value) => nombre = value!,
          ),
          TextFormField(
            decoration:const  InputDecoration(labelText: 'Apellido'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese el apellido';
              }
              return null;
            },
            onSaved: (value) => apellido = value!,
          ),
          TextFormField(
            decoration:const  InputDecoration(labelText: 'Correo'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese la correo';
              }
              return null;
            },
            onSaved: (value) => correo = value!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Verificar si 'ced_cli' ya existe en la base de datos
                    var query = await FirebaseFirestore.instance
                        .collection('clientes')
                        .where('ced_cli', isEqualTo: cedula)
                        .get();

                    if (query.docs.isEmpty && _validarDatos(cedula, nombre,apellido,correo,context)) {

                      // Si 'ced_cli' no existe en la base de datos, puedes enviar los datos
                      FirebaseFirestore.instance.collection('clientes').add({
                        'ced_cli': cedula,
                        'nom_cli': nombre,
                        'ape_cli': apellido,
                        'cor_cli': correo,
                      });

                      Navigator.pop(
                          context); // Cerrar el modal después de enviar
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                     const    SnackBar(
                          content:  Text(
                            'El cliente ya está registrado',
                            style:  TextStyle(
                                color: Colors.white), // Color de texto blanco
                          ),
                          backgroundColor: Colors.red, // Color de fondo rojo
                        ),
                      );

                      Navigator.pop(
                          context); // Cerrar el modal después de mostrar el mensaje de error
                    }
                  }
                },
                child:const  Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cerrar el modal sin hacer nada
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validarDatos(String cedula, String nombre, String apellido,
      String correo, BuildContext context) {
    // Validar la cédula ecuatoriana
    if (!validarCedulaEcuatoriana(cedula)) {
      _mostrarMensajeError(context, 'La cédula ingresada no es válida.');
      return false;
    }

    // Validar el correo electrónico
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(correo)) {
      _mostrarMensajeError(
          context, 'El correo electrónico no tiene un formato válido.');
      return false;
    }

    // Validar que los otros campos no estén vacíos
    if (nombre.isEmpty || apellido.isEmpty || correo.isEmpty) {
      _mostrarMensajeError(context, 'Todos los campos son obligatorios.');
      return false;
    }
    return true;
  }

  void _mostrarMensajeError(BuildContext context, String mensaje) {
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
