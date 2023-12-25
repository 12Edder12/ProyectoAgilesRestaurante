import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../widgets/widgets.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key, required this.user});

  final User user;

  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _apeUserController = TextEditingController();
  final _celUserController = TextEditingController();
  final _dirUserController = TextEditingController();
  final _emailController = TextEditingController();
  final _fecNacUserController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name;
    _roleController.text = user.role;
    _apeUserController.text = user.apeUser;
    _celUserController.text = user.celUser;
    _dirUserController.text = user.dirUser;
    _emailController.text = user.email;
    _fecNacUserController.text = DateFormat('dd-MM-yyyy').format(user.fecNacUser.toDate());



    final theme = Theme.of(context);
        return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _roleController,
            decoration: InputDecoration(labelText: 'Role'),
          ),
          TextFormField(
            controller: _apeUserController,
            decoration: InputDecoration(labelText: 'Apellido'),
          ),
          TextFormField(
            controller: _celUserController,
            decoration: InputDecoration(labelText: 'Celular'),
          ),
          TextFormField(
            controller: _dirUserController,
            decoration: InputDecoration(labelText: 'Dirección'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _fecNacUserController,
            decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
          ),
          const Gap(16),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            onPressed: () {
              // Aquí puedes llamar a una función para actualizar los datos del usuario en tu base de datos
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
