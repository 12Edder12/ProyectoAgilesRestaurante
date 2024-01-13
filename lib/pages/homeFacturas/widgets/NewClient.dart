import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NuevoClienteModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _mostrarFormularioNuevoCliente(context);
      },
      child: Text('Añadir Cliente'),
    );
  }

  void _mostrarFormularioNuevoCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Añadir Cliente'),
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
            decoration: InputDecoration(labelText: 'Cédula'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese la cédula';
              }
              return null;
            },
            onSaved: (value) => cedula = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese el Nombre';
              }
              return null;
            },
            onSaved: (value) => nombre = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Apellido'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese el apellido';
              }
              return null;
            },
            onSaved: (value) => apellido = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Correo'),
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

                    // Aquí puedes enviar los datos a Firebase
                    FirebaseFirestore.instance.collection('clientes').add({
                      'ced_cli': cedula,
                      'nom_cli': nombre,
                      'ape_cli': apellido,
                      'cor_cli': correo,
                    });

                    Navigator.pop(context); // Cerrar el modal después de enviar
                  }
                },
                child: Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cerrar el modal sin hacer nada
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
