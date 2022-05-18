import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

AuthMethods authMethods = AuthMethods();

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          // if (snapshot.hasError) {
          //   return const Center(
          //     child: Text('Something went wrong'),
          //   );
          // }

          // Once complete, show your application
          // if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: IconButton(
              onPressed: () {
                setState(() {
                  isUserLoggedIn = false;
                });
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const SignIn()));
              },
              icon: const Icon(Icons.logout))),
    );
  }
    );
}
}