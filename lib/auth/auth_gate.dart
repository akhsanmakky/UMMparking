import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/menu_utama.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ SUDAH LOGIN
        if (snapshot.hasData) {
          return MenuUtama();
        }

        // ❌ BELUM LOGIN
        return const LoginScreen();
      },
    );
  }
}
