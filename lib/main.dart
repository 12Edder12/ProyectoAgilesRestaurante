import 'package:bbb/firebase_options.dart';
import 'package:bbb/services/auth/auth_gath.dart';
import 'package:bbb/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';


//eddernc@hotmail.com
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
try {
    Stripe.publishableKey = "pk_test_51OVR6tILXmRhmPFR0a3rWTTW4SUX1YFLkjaD6XWmeglplW5kcR49Vr6SutZLVF7tUgwtkqv3cup9pGJeDmABtFKW00iNQTABD6";
    print('*********************************Stripe se ha inicializado correctamente');
  } catch (e) {
    print('**********************************Error al inicializar Stripe: $e');
  }

  if (!kIsWeb) {
    try {
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
OneSignal.initialize("96221739-4b13-46a8-825b-2987269a801b");
OneSignal.Notifications.requestPermission(true);
    // print('Todo está bien con OneSignal');

} catch (e) {
  //     print('Error al inicializar OneSignal: $e');
    }
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseApi().initNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
