import 'package:Pizzeria_Guerrin/constants/globals.dart';
import 'package:Pizzeria_Guerrin/pages/homeFacturas/factura.dart';
import 'package:Pizzeria_Guerrin/pages/mesas.dart';
import 'package:Pizzeria_Guerrin/services/auth/auth_service.dart';
import 'package:Pizzeria_Guerrin/services/auth/login_or_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TomarMesa extends StatefulWidget {
  const TomarMesa({super.key});

  @override
  State<TomarMesa> createState() => _TomarMesaState();
}

class _TomarMesaState extends State<TomarMesa> {
  @override
  void initState() {
    super.initState();
    obtenerDatosUsuario();
  }

  void obtenerDatosUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot usuarios = await db
        .collection('users')
        .where('email', isEqualTo: usuario!.email)
        .get();

    if (usuarios.docs.isNotEmpty) {
      datosUsuario = usuarios.docs.first.data() as Map<String, dynamic>;
    } else {
      // Si no se encontró ningún usuario con el correo especificado, lanza una excepción
      throw Exception(
          'No se encontró ningún usuario con el correo especificado');
    }
  }

  Future<void> signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  static final elevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(const Color(0xFFEB8F1E)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.grey,
          width: 5.0,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Mesero'),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await signOut();
              }),
        ],
      ),
      body: Stack(children: [
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            "lib/img/xd.jpeg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            right: 8,
            left: 8,
            bottom: 15,
          ),
          child: Column(children: <Widget>[
            Container(
              width: double.infinity, // Ancho completo de la pantalla
              color: Colors.transparent, // Color de fondo blanco
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: const Column(
                children: <Widget>[
                  Text(
                    "Pizzería Güerrín",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 42,
                      fontFamily: AutofillHints.countryName,
                    ),
                  ),
                  // Resto de tu código...
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Mesas()));
                        },
                        style: elevatedButtonStyle,
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'lib/img/mesas.png',
                              ),
                              const Text(
                                "Asignar Mesas",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Factura()),
                          );
                        },
                        style: elevatedButtonStyle,
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Image.asset(
                                  'lib/img/factura.png', // Asegúrate de tener una imagen para facturar
                                ),
                              ),
                              const Text(
                                "Facturar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ]),
    );
  }
}
