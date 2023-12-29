import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PushNotificationProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  void guardarTokenEnFirestore() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('tokens').add({
      'token': token,
    });
  }

  initNotification() {
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print('======== FCM TOKEN ===========');
      guardarTokenEnFirestore();
      print(token);
    });

    var notification = FirebaseFirestore.instance
        .collection('pedidos')
        .snapshots()
        .listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          // Nuevo pedido agregado
        }
        // Puedes agregar más lógica para otros tipos de cambios si es necesario
      }
    });

    void enviarNotificacionACocineros(DocumentSnapshot doc) {
      // Aquí, puedes implementar la lógica para enviar una notificación a los cocineros.
      // Por ejemplo, puedes utilizar Firebase Messaging para enviar una notificación.
      // Puedes acceder a los datos del documento (pedido) utilizando el parámetro 'doc'.
      print(
          'Nuevo pedido detectado: ${doc.data()}'); // Solo como ejemplo, puedes enviar una notificación real aquí.
    }
  }

  void setupNotification() {
  // Escuchar cambios en una colección específica
  _firestore.collection('tuColeccion').snapshots().listen((snapshot) {
    snapshot.docChanges.forEach((change) {
      if (change.type == DocumentChangeType.added) {
        // Aquí se puede enviar una notificación usando FCM
        _sendNotification('Nuevo Dato Agregado', 'Se ha agregado un nuevo dato en Firebase.');
      }
    });
  });
}

void _sendNotification(String title, String body) {
  // Aquí se configura y envía la notificación utilizando FCM
  // Puedes adaptar este método según tus necesidades específicas y la lógica de tu aplicación
  _firebaseMessaging.showNotification(
    title: title,
    body: body,
    // Aquí puedes agregar otros parámetros como icono, sonido, etc.
  );
}

  dispose() {
    _mensajesStreamController.close();
  }
}
