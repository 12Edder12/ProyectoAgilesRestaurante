import 'package:Pizzeria_Guerrin/pages/homeFacturas/widgets/boton_mesas.dart';
import 'package:Pizzeria_Guerrin/services/auth/auth_service.dart';
import 'package:Pizzeria_Guerrin/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Factura extends StatelessWidget {
  const Factura({super.key});

  Future<void> signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pedidos Pizza Guerrin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFEB8F1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await signOut(context);
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: Botones(),
          ),
        ],
      ),
    );
  }
}
