import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/views/dashboard_screen.dart';
import 'package:todolist_app/views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAlLFkhk9k_-AEy4zHl6-A2JfJWxDxArkM',
          appId: '1:149514599204:web:a34badcc82623bcfcc91b1',
          messagingSenderId: '149514599204',
          projectId: 'todolist-app-fad3a',
          storageBucket: 'todolist-app-fad3a.firebaseapp.com'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo list App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}
