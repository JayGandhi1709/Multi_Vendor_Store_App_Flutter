import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vender_store_app/views/buyers/auth/login_screen.dart';
import 'package:multi_vender_store_app/views/buyers/landing_screen.dart';

class BuyerAuthScreen extends StatefulWidget {
  const BuyerAuthScreen({super.key});

  @override
  State<BuyerAuthScreen> createState() => _BuyerAuthScreenState();
}

class _BuyerAuthScreenState extends State<BuyerAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      initialData: _auth.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        return const LandingScreen();
      },
    );
  }
}
