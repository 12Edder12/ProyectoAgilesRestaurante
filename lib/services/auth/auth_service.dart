import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<bool> isEmailTaken(String email) async {
  final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  return result.docs.isNotEmpty;
}


  int loginAttempts = 0;
  bool isBlocked = false;

Future<DocumentSnapshot<Object?>> signInWithEmailPassword
(String email, String password) async {
if (isBlocked) {
      throw Exception("El sistema está bloqueado temporalmente. Intenta de nuevo más tarde.");
    }

  try{
    UserCredential userCredential = 
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );

       DocumentSnapshot userDoc = await _firebaseFirestore.collection('users')
      .doc(userCredential.user!.uid).get();

      loginAttempts = 0;

    return userDoc;
   
 } on FirebaseAuthException catch (e) {
     loginAttempts++;

if (loginAttempts >= 3) {
        isBlocked = true;
        Future.delayed(Duration(seconds: 10), () {
          // Desbloquear el sistema después de 10 segundos
          isBlocked = false;
          loginAttempts = 0;
        });
      }

    throw Exception(e.code);
    
  }
}


 Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Cierre de sesión exitoso');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

Future<UserCredential> signUpWithEmailandPassword
(String email, String password, String cargo) async {
  try{
    UserCredential userCredential =
     await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
      );


      _firebaseFirestore.collection('users')
      .doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'cargo':cargo,
      });

      return userCredential;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

  }