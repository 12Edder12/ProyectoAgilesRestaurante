import 'package:bbb/firebase_options.dart';
import 'package:bbb/providers/push_notification_providers.dart';
import 'package:bbb/services/auth/auth_gath.dart';
import 'package:bbb/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbb/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBWEVknDXHNn8bpEGiClm611NnOv4nQ2Pg",
          appId: "1:409171923627:web:842a56f8699b7c128addee",
          messagingSenderId: "409171923627",
          projectId: "edder3-fd79d")
  );

  final pushProvider = PushNotificationProvider();
  pushProvider.initNotification();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp>{
  @override
  void initState(){
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('NOTIFICACTION TITLE:${notification!.title}');
      showModalBottomSheet(
          context: context,
          builder: ((context) {
            return Container(
              child: Column(
                  children: [
                    Text(notification.title.toString()),
                    Text(notification.body.toString(),)
                  ],
              ),
            );
          }));
      print("COMPLETE SHOW MODAL BOTTOMSHEET");
    });
  }
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
