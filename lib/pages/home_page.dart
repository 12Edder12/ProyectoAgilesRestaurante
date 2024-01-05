import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbb/services/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esperando asignación de rol'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Por favor espera mientras el administrador asigna tu rol.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}