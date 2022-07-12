import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfservice/screens/authenticate/authenticate.dart';
import 'package:selfservice/screens/home/rolebasedhomes/directeurHome.dart';
import 'package:selfservice/screens/home/rolebasedhomes/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser!;
            if (user.uid == 'P3MDpi3ZU2P7urQBASq5oloQTcx1') {
              return directeurHome();
            } else {
              return Home();
            }
          } else {
            return Authenticate();
          }
        },
      ));
}
