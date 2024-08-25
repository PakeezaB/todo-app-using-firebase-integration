import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameC, mobileC, emailC, passC, confirmC;
  String selectedGender = 'Male';

  @override
  void initState() {
    nameC = TextEditingController();
    mobileC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    confirmC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    mobileC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            TextField(
              controller: mobileC,
              decoration: const InputDecoration(
                hintText: 'Mobile',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
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
            TextField(
              controller: confirmC,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            CupertinoSegmentedControl(
              groupValue: selectedGender,
              children: const {
                'Male': Text('Male'),
                'Female': Text('Female'),
                'Other': Text('Other')
              },
              onValueChanged: (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            ElevatedButton(
              onPressed: () async {
                String name = nameC.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please provide name')));
                  return;
                }

                String mobile = mobileC.text.trim();
                String email = emailC.text.trim();
                String pass = passC.text.trim();
                String confirmPass = confirmC.text.trim();

                if (pass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords must match')));
                  return;
                }

                // If everything is OK
                FirebaseAuth auth = FirebaseAuth.instance;

                try {
                  UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                          email: email, password: pass);

                  if (userCredential.user != null) {
                    // Now store other info to database
                    String uid = userCredential.user!.uid;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'uid': uid,
                      'name': name,
                      'mobile': mobile,
                      'email': email,
                      'gender': selectedGender,
                      'photo': null,
                      'createdOn':
                          DateTime.now().millisecondsSinceEpoch, // Timestamp
                    });

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account Created')));
                  }
                } on FirebaseAuthException catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message!)));
                }
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 16), // Replaced Gap(16) with SizedBox
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Already Registered? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
