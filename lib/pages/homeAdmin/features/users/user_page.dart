import 'package:bbb/constants/globals.dart';
import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:bbb/pages/homeAdmin/features/users/users_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.user});

  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

const String adminUserId = 'mfXLo5670Sfm5meTcFOIlBXRaM83';
class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
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
    _ageController = TextEditingController(
        text: calculateAge(widget.user.fecNacUser).toString());
    _cedulaController = TextEditingController(text: widget.user.userId);
    _nameController = TextEditingController(text: widget.user.name);
    _apeUserController = TextEditingController(text: widget.user.apeUser);
    _celUserController = TextEditingController(text: widget.user.celUser);
    _dirUserController = TextEditingController(text: widget.user.dirUser);
    _emailController = TextEditingController(text: widget.user.email);
    idUser = widget.user.idFirebase;
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.user.idFirebase == adminUserId;
    return ContentView(
        child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _cedulaController,
              decoration: const InputDecoration(labelText: 'Cédula'),
              enabled: false,
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              enabled: _isEditing,
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                  return 'El nombre solo debe contener letras';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _apeUserController,
              decoration: const InputDecoration(labelText: 'Apellido'),
              enabled: _isEditing,
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un apellido';
                } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                  return 'El apellido solo debe contener letras';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: 'Cargo'),
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              items: _roles.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontSize: 16), // Cambia el tamaño de la letra aquí
                  ),
                );
              }).toList(),
              onChanged: _isEditing
                  ? (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    }
                  : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              enabled: false,

            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              enabled: false,
            ),
            TextFormField(
              controller: _celUserController,
              decoration: const InputDecoration(labelText: 'Celular'),
              style: TextStyle(
                color: _isEditing
                    ? Colors.black
                    : Colors.black87, // Cambia el color del texto aquí
              ),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un número de celular';
                } else if (value.length != 10 ||
                    !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'El número de celular debe tener 10 dígitos y solo contener números';
                }
                return null;
              },
            ),
            TextFormField(
                controller: _dirUserController,
                decoration: const InputDecoration(labelText: 'Direccion'),
                style: TextStyle(
                  color: _isEditing
                      ? Colors.black
                      : Colors.black87, // Cambia el color del texto aquí
                ),
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una direccion';
                  } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'La direccion solo debe contener letras';
                  }
                }),

            // Agrega aquí los demás campos
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Centra los botones en la fila
              children: [
                if (_isEditing && !isAdmin)
                  Flexible(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12, // Cambia el tamaño del texto a 12
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Cambia el color de fondo a rojo
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                      },
                    ),
                  ),
                if (!_isEditing && !isAdmin)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Editar',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Cambia el color de fondo a azul
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                  ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Guardar',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Cambia el color de fondo a verde
                  ),
                  onPressed: () async {
                    if (_isEditing && !isAdmin) {
                      if (_formKey.currentState!.validate()) {
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
                          await userService.updateUser(
                              widget.user.idFirebase, newUserData);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuario actualizado con éxito')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Error al actualizar el usuario: $e')),
                          );
                        }

                        setState(() {
                          _isEditing = false;
                        });
                      }
                    }
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Eliminar',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Cambia el color de fondo a rojo
                  ),
                  onPressed: isAdmin ? null : () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text(
                          'Confirmar eliminación',
                          style: TextStyle(
                              color: Colors
                                  .red), // Cambia el color del título a rojo
                        ),
                        content: const Text(
                          '¿Estás seguro de que quieres eliminar este usuario?',
                          style: TextStyle(
                              color: Colors
                                  .black), // Cambia el color del contenido a negro
                        ),
                        actions: <Widget>[
                          TextButton.icon(
                            icon: const Icon(Icons.cancel,
                                color:
                                    Colors.red), // Añade un icono de cancelar
                            label: const Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors
                                      .red), // Cambia el color del texto a rojo
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(false);
                            },
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.delete,
                                color:
                                    Colors.red), // Añade un icono de eliminar
                            label: const Text(
                              'Eliminar',
                              style: TextStyle(
                                  color: Colors
                                      .red), // Cambia el color del texto a rojo
                            ),
                            onPressed: () async {
                              final userService = UserService();
                              try {
                                await userService.deleteUser(idUser);
                                Navigator.of(dialogContext).pop(true);

                                // Comprueba si globalContext no es null antes de usarlo
                                if (globalContext != null) {
                                  showDialog(
                                    context: globalContext!,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Usuario eliminado',
                                        style: TextStyle(
                                            color: Colors
                                                .green), // Cambia el color del título a verde
                                      ),
                                      content: const Text(
                                        'El usuario ha sido eliminado con éxito.',
                                        style: TextStyle(
                                            color: Colors
                                                .black), // Cambia el color del contenido a negro
                                      ),
                                      actions: <Widget>[
                                        TextButton.icon(
                                          icon: const Icon(Icons.check,
                                              color: Colors
                                                  .green), // Añade un icono de check
                                          label: const Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors
                                                    .green), // Cambia el color del texto a verde
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Cerrar el AlertDialog
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error al eliminar el usuario: $e'),
                                  ),
                                );
                                Navigator.of(dialogContext).pop(false);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

int calculateAge(Timestamp birthDate) {
  final birthDateTime = birthDate.toDate();
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDateTime.year;
  if (currentDate.month < birthDateTime.month ||
      (currentDate.month == birthDateTime.month &&
          currentDate.day < birthDateTime.day)) {
    age--;
  }
  return age;
}
