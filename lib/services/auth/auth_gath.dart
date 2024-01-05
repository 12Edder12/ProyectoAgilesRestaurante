import 'package:bbb/pages/homeAdmin/home_admin.dart';
import 'package:bbb/pages/homeCocinero/homecocinero.dart';
import 'package:bbb/pages/homeMesero/tomar_mesa.dart';
import 'package:bbb/pages/home_page.dart';
import 'package:bbb/services/auth/login_or_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder( 
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          if(snapshot.hasData){
          String? uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) {
            return const LoginOrRegister();
          }
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String? cargo = snapshot.data?['cargo'];
                  if (cargo == null) {
                    return const HomePage(); 
                  }
                  if (cargo == 'Cocinero') {
                    return const HomeCocinero();
                  } else if (cargo == 'Mesero') {
                    return const TomarMesa();
                  } else if (cargo == 'admin') {
                    return const AdminScreen();
                  }
                  else {
                    return const HomePage();
                  }
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                // Mientras el documento se está obteniendo, muestra un indicador de carga
                return const CircularProgressIndicator();
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}