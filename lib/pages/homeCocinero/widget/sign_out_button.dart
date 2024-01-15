// En auth_sign_out_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Pizzeria_Guerrin/services/auth/auth_service.dart';
import 'package:Pizzeria_Guerrin/services/auth/login_or_register.dart';

class AuthSignOutButton extends StatelessWidget {
  const AuthSignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () async {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginOrRegister()),
        );
      },
    );
  }
}
