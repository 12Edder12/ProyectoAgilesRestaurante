import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:bbb/pages/homeAdmin/features/users/users_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../widgets/widgets.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final TextEditingController _cedulaController;
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _apeUserController;
  late final TextEditingController _celUserController;
  late final TextEditingController _dirUserController;
  late final TextEditingController _emailController;
  late final TextEditingController _fecNacUserController;
  
  // Agrega aquí los demás controladores

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _cedulaController = TextEditingController(text: widget.user.userId);
    _nameController = TextEditingController(text: widget.user.name);
    _roleController = TextEditingController(text: widget.user.role);
    _apeUserController = TextEditingController(text: widget.user.apeUser);
    _celUserController = TextEditingController(text: widget.user.celUser);
    _dirUserController = TextEditingController(text: widget.user.dirUser);
    _emailController = TextEditingController(text: widget.user.email);

  }

  @override
  Widget build(BuildContext context) {
    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _cedulaController,
            decoration: InputDecoration(labelText: 'Cédula'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _apeUserController,
            decoration: InputDecoration(labelText: 'Apellido'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _celUserController,
            decoration: InputDecoration(labelText: 'Celular'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _dirUserController,
            decoration: InputDecoration(labelText: 'Direccion'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _roleController,
            decoration: InputDecoration(labelText: 'Cargo'),
            enabled: _isEditing,
          ),

          // Agrega aquí los demás campos
          const Gap(16),
          if (_isEditing)
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
           ElevatedButton.icon(
            
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            onPressed: () async {
            if (_isEditing) {
            final dateFormat = DateFormat('dd/MM/yyyy');
            final birthDate = dateFormat.parse(_fecNacUserController.text);
            final newUserData = {
            'nom_user': _nameController.text,
            'ape_user': _apeUserController.text,
            'cel_user': _celUserController.text,
            'cargo': _roleController.text,
            'dir_user': _dirUserController.text,
            'email': _emailController.text,
            'fec_nac_user': Timestamp.fromDate(birthDate),  
            // Agrega aquí el resto de los campos del usuario
          };
            final userService = UserService();
            try {
              await userService.updateUser(widget.user.idFirebase, newUserData);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Usuario actualizado con éxito')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al actualizar el usuario: $e')),
              );
            }
      
            setState(() {
              _isEditing = false;
            });
          }
        },
), 
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            onPressed: () {
              // Aquí puedes llamar a una función para eliminar al usuario de tu base de datos
            },
          ),

        ],
      ),
    );
  }
}
