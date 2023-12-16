import 'package:bbb/pages/components/my_button.dart';
import 'package:bbb/pages/components/my_text_field.dart';
import 'package:bbb/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key,
  required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmpassController = TextEditingController();
  String? dropdownValue;

bool isEmailValid(String email) {
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|yahoo.com)$');
  return emailRegex.hasMatch(email);
}


void signUp() async {
  if (passController.text.trim() != confirmpassController.text.trim()){
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

  final authService = Provider.of<AuthService>(context, listen:false);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
  


    final isEmailTaken = await authService.isEmailTaken(emailController.text);
    if (isEmailTaken) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Este correo ya está registrado"),
        ),
      );
    }
    else {
    await authService.signUpWithEmailandPassword(
      emailController.text,
      passController.text,
      dropdownValue ?? 'No seleccionado',

    ); }
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
      ),),
    Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image.asset(
      "lib/img/res_logo.png",
      width: 80,
      height: 80,
      ),
        const  Text("Registrate",
          style: TextStyle(
            fontSize: 16, 
          ),
          ), 
      
          //email
          MyTextField(
          controller: emailController, 
          hintText: "Email", 
          obscureText: false),
          //password
          
        const SizedBox(height: 10,),

          MyTextField(
          controller: passController, 
          hintText: "Contraseña", 
          obscureText: false),
      
          // sign un buttonn
      const SizedBox(height: 10,),


 MyTextField(
          controller: confirmpassController, 
          hintText: "Confirmar Contraseña", 
          obscureText: false),
      
          // sign un buttonn
          const SizedBox(height: 10,),
Container(
  padding: const EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  child: DropdownButton<String>(
    value: dropdownValue,
    hint: const Text('Seleccione el cargo'),
    onChanged: (String? newValue) {
      setState(() {
        dropdownValue = newValue;
      });
    },
    items: <String>['Cocinero', 'Mesero']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
  ),
),


const SizedBox(height: 10,),

           MyButton(onTap: signUp, text: "Crear"),


          // register 
     Row (
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
         const  Text("Tienes cuenta?"),
          const  SizedBox(width: 10,),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text("Login", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            )
            ] 
            ),
        ],
      ),
    ),
    ),
    ]),
    ));
  }
}