import 'package:bbb/pages/components/my_button.dart';
import 'package:bbb/pages/components/my_text_field.dart';
import 'package:bbb/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime? fechaNacimiento;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmpassController = TextEditingController();
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final direccionController = TextEditingController();
  final celularController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  String? dropdownValue;

  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|yahoo.com)$');
    return emailRegex.hasMatch(email);
  }

  bool validarCedulaEcuatoriana(String cedula) {
    if (cedula.length != 10) {
      return false;
    }

    int provincia = int.parse(cedula.substring(0, 2));

    if (provincia < 1 || provincia > 24) {
      return false;
    }

    int tercerDigito = int.parse(cedula.substring(2, 3));
    if (tercerDigito > 5) {
      return false;
    }

    int suma = 0;
    for (int i = 0; i < 9; i++) {
      int digito = int.parse(cedula[i]);
      if (i % 2 == 0) {
        digito = digito * 2;
        if (digito > 9) {
          digito = digito - 9;
        }
      }
      suma += digito;
    }

    int ultimoDigito = (suma % 10) == 0 ? 0 : 10 - (suma % 10);
    return ultimoDigito == int.parse(cedula[9]);
  }

  bool validarNumeroCelularEcuador(String numero) {
    // Verificar la longitud del número
    if (numero.length != 10) {
      return false;
    }

    // Verificar que comience con '09'
    if (!numero.startsWith('09')) {
      return false;
    }

    // Verificar que todos los caracteres sean dígitos
    for (int i = 0; i < numero.length; i++) {
      if (numero[i].compareTo('0') < 0 || numero[i].compareTo('9') > 0) {
        return false;
      }
    }

    // Si todas las validaciones anteriores son correctas, el número es válido
    return true;
  }

  bool validarNombreApellido(String nombreApellido) {
    // Verificar que todos los caracteres sean letras
    return RegExp(r'^[a-zA-Z]+$').hasMatch(nombreApellido);
  }

  void signUp() async {
    if (nombreController.text.trim().isEmpty ||
        apellidoController.text.trim().isEmpty ||
        direccionController.text.trim().isEmpty ||
        celularController.text.trim().isEmpty ||
        cedulaController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passController.text.trim().isEmpty ||
        confirmpassController.text.trim().isEmpty ||
        fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Todos los campos deben estar completos"),
        ),
      );
      return;
    }
    if (passController.text.trim() != confirmpassController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden"),
        ),
      );
      return;
    }

    if (!isEmailValid(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El correo ingresado es invalido verificar nuevamente"),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final isCedulaTaken =
          await authService.isCedulaTaken(cedulaController.text.trim());
      final isEmailTaken = await authService.isEmailTaken(emailController.text);
      if (isEmailTaken) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Este correo ya está registrado"),
          ),
        );
      } else if (isCedulaTaken) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Esta cédula ya está registrada"),
          ),
        );
      } else if (!validarCedulaEcuatoriana(cedulaController.text.trim())) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("La cédula no es válida"),
          ),
        );
      } else if (!validarNumeroCelularEcuador(celularController.text.trim())) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("El número de teléfono no es válido"),
          ),
        );
      } else if (!validarNombreApellido(nombreController.text.trim()) ||
          !validarNombreApellido(apellidoController.text.trim())) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("El nombre y apellido solo deben contener letras"),
          ),
        );
      } else {
        DateTime fechaUtc = fechaNacimiento!.toUtc();
        DateTime fechaAjustada =
            DateTime(fechaUtc.year, fechaUtc.month, fechaUtc.day, 12);
        await authService.signUpWithEmailandPassword(
          emailController.text.trim(), // email
          passController.text, // password
          nombreController.text.trim(), // nom_user
          apellidoController.text.trim(), // ape_user
          direccionController.text, // dir_user
          celularController.text.trim(), // cel_user
          cedulaController.text.trim(), // ced_user
          fechaAjustada, // fecha
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Error al crear la cuenta"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Stack(children: [
            // Fondo de pantalla
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                "lib/img/xd.jpeg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/img/res_logo.png",
                        width: 80,
                        height: 80,
                      ),
                      const Text(
                        "Registrate",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      //email
                      MyTextField(
                          controller: cedulaController,
                          hintText: "Cédula",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: nombreController,
                          hintText: "Nombre",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: apellidoController,
                          hintText: "Apellido",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: direccionController,
                          hintText: "Dirección",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: celularController,
                          hintText: "Celular",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(fontSize: 16),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          fechaNacimiento == null
                              ? 'Seleccionar fecha de nacimiento'
                              : 'Fecha de nacimiento: ${DateFormat('dd-MM-yyyy').format(fechaNacimiento!)}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          final fechaSeleccionada = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (fechaSeleccionada != null) {
                            final edad = DateTime.now()
                                    .difference(fechaSeleccionada)
                                    .inDays ~/
                                365;
                            if (edad < 18) {
                              // Muestra un mensaje de error si la persona tiene menos de 18 años
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Debes tener al menos 18 años.')),
                              );
                            } else {
                              setState(() {
                                fechaNacimiento = fechaSeleccionada;
                              });
                            }
                          }
                        },
                      ),
                      // sign un buttonn
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false),
                      //password

                      const SizedBox(
                        height: 10,
                      ),

                      MyTextField(
                          controller: passController,
                          hintText: "Contraseña",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),

                      MyTextField(
                          controller: confirmpassController,
                          hintText: "Confirmar Contraseña",
                          obscureText: false),

                      // sign un buttonn
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      MyButton(onTap: signUp, text: "Crear"),

                      // register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Tienes cuenta?"),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
