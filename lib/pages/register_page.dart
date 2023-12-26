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

  void signUp() async {
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
      final isEmailTaken = await authService.isEmailTaken(emailController.text);
      if (isEmailTaken) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Este correo ya está registrado"),
          ),
        );
      } else {
         DateTime fechaUtc = fechaNacimiento!.toUtc();
DateTime fechaAjustada = DateTime(fechaUtc.year, fechaUtc.month, fechaUtc.day, 12);
        await authService.signUpWithEmailandPassword(
          emailController.text, // email
          passController.text, // password
          nombreController.text, // nom_user
          apellidoController.text, // ape_user
          direccionController.text, // dir_user
          celularController.text, // cel_user
          cedulaController.text, // ced_user
          fechaAjustada,// fecha
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
                
                child : SingleChildScrollView(
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
                      child: Text(fechaNacimiento == null
                          ? 'Seleccionar fecha de nacimiento'
                          : 'Fecha de nacimiento: ${fechaNacimiento!.toIso8601String()}'),
                      onPressed: () async {
                        final fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (fechaSeleccionada != null) {
                          setState(() {
                            fechaNacimiento = fechaSeleccionada;
                          });
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
