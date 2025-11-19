import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/home/home_page.dart';
import 'package:marketplace_app/authentication/login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // This StreamBuilder listens to the login status
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. If it's still loading, show a spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. If user data exists (they are logged in)
        if (snapshot.hasData) {
          return const HomePage();
        }

        // 3. If data is null (they are logged out)
        return const LoginScreen(); // Show the Login Page
      },
    );
  }
}
