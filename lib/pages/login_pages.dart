import 'package:bbb/pages/homeCocinero/homecocinero.dart';
import 'package:bbb/pages/homeMesero/tomar_mesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbb/pages/components/my_button.dart';
import 'package:bbb/pages/components/my_text_field.dart';
import 'package:bbb/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  void navigateToPage(String cargo) {
    if (cargo == 'Cocinero') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeCocinero()),
      );
    } else if (cargo == 'Mesero') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TomarMesa()),
      );
    }
  }

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      DocumentSnapshot userDoc = await authService.signInWithEmailPassword(
          emailController.text, passController.text);

      String cargo = userDoc['cargo'];
      navigateToPage(cargo);
    } catch (e) {
      showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/img/res_logo.png",
                       width: 150,  // Ancho de la imagen
                       height: 150,
                    ),
                    const Text(
                      "Hola, le saluda la pizzería Guerrín",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Contenedor para englobar los campos y el botón
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          // Email
                          MyTextField(
                            controller: emailController,
                            hintText: "Correo",
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          // Contraseña
                          MyTextField(
                            controller: passController,
                            hintText: "Contraseña",
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          // Botón de entrar
                          MyButton(onTap: signIn, text: "Entrar"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No tienes cuenta?"),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Regístrate Ahora",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
