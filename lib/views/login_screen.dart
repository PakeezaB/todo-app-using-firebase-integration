import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/views/dashboard_screen.dart';
import 'package:todolist_app/views/email_verification.dart';
import 'package:todolist_app/views/forgot_password_screen.dart';
import 'package:todolist_app/views/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailC, passC;

  @override
  void initState() {
    emailC = TextEditingController();
    passC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            TextField(
              controller: passC,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            ElevatedButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;

                try {
                  UserCredential userCredentials =
                      await auth.signInWithEmailAndPassword(
                          email: emailC.text.trim(),
                          password: passC.text.trim());

                  if (userCredentials.user!.emailVerified) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const DashboardScreen();
                    }));
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const EmailVerificationScreen();
                    }));
                  }
                } on FirebaseAuthException catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message!)));
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const SignUpScreen();
                  }));
                },
                child: const Text('Not Registered Yet? Sign up')),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ForgotPasswordScreen();
                  }));
                },
                child: const Text('Forgot Password')),
          ],
        ),
      ),
    );
  }
}
