import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:bbb/pages/homeAdmin/features/users/users_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  late final TextEditingController _apeUserController;
  late final TextEditingController _celUserController;
  late final TextEditingController _dirUserController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  List<String> _roles = ['Mesero', 'Cocinero', 'admin', 'No definido'];
  String? _selectedRole;
  // Agrega aquí los demás controladores

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    _ageController = TextEditingController(text: calculateAge(widget.user.fecNacUser).toString());
    _cedulaController = TextEditingController(text: widget.user.userId);
    _nameController = TextEditingController(text: widget.user.name);
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
          DropdownButtonFormField<String>(  
          value: _selectedRole,
          decoration: InputDecoration(labelText: 'Cargo'),
          items: _roles.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _isEditing ? (String? newValue) {
            setState(() {
              _selectedRole = newValue;
            });
          } : null,
        ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Edad'),
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
            final newUserData = {
            'nom_user': _nameController.text,
            'ape_user': _apeUserController.text,
            'cel_user': _celUserController.text,
            'cargo': _selectedRole,
            'dir_user': _dirUserController.text,
            'email': _emailController.text, 
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

int calculateAge(Timestamp birthDate) {
  final birthDateTime = birthDate.toDate();
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDateTime.year;
  if (currentDate.month < birthDateTime.month ||
      (currentDate.month == birthDateTime.month && currentDate.day < birthDateTime.day)) {
    age--;
  }
  return age;
}
