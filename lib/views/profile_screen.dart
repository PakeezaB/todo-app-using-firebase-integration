import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot? userSnapshot;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        currentUser = user;
        getUserDetails();
      } else {
        setState(() {
          currentUser = null;
          userSnapshot = null;
        });
      }
    });
  }

  Future<void> getUserDetails() async {
    if (currentUser != null) {
      String uid = currentUser!.uid;
      userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userSnapshot != null
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            userSnapshot!['gender'] == 'male'
                                ? 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngegg.com%2Fen%2Fpng-zyjhv&psig=AOvVaw3sfP9wdfoysHukSWD6ITPi&ust=1724677269823000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCJjwt9KZkIgDFQAAAAAdAAAAABAE'
                                : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.emito.net%2Fl%2Fhttp%2Fe10.beauty%2Ffemale-avatar-icon&psig=AOvVaw1Rsx10tDaeoNwmtUULNtko&ust=1724677181507000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCOCajq-ZkIgDFQAAAAAdAAAAABAP',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(userSnapshot!['name']),
                Text(userSnapshot!['gender']),
                Text(userSnapshot!['email']),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
