import 'package:app_pasanaku/firebase_options.dart';
import 'package:app_pasanaku/views/Login.dart';
import 'package:app_pasanaku/views/Notificacion.dart';
import 'package:app_pasanaku/views/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  requestNotificationPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  print("Notification permission granted: ${settings.authorizationStatus}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _email;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    _loadEmailFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _email.isEmpty ? const Login() : const Home(),
    );
  }

  Future<void> _loadEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ??
        ''; // Si no hay valor, asignamos un valor por defecto
    setState(() {
      _email = email;
    });
  }
}
