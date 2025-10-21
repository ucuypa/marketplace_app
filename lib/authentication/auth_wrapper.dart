import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
// import 'buyer_home_screen.dart';
// import 'seller_dashboard_screen.dart';
// import 'loading_screen.dart'; // A simple screen with a CircularProgressIndicator

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // User is logged in, but we need to check their role
        final User user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, userDocSnapshot) {
            // Still waiting for Firestore to respond
            if (userDocSnapshot.connectionState == ConnectionState.waiting) {
              // return const LoadingScreen(); // Show a loading spinner
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Error fetching document
            if (!userDocSnapshot.hasData || !userDocSnapshot.data!.exists) {
              // Something went wrong, log them out and send to login
              FirebaseAuth.instance.signOut();
              return const LoginScreen();
            }

            // We have the data, let's check the role
            final String role = userDocSnapshot.data!.get('role');
            if (role == 'buyer') {
              // return const BuyerHomeScreen();
              return const Scaffold(
                body: Center(child: Text("Buyer Home")),
              ); // Placeholder
            } else {
              // return const SellerDashboardScreen();
              return const Scaffold(
                body: Center(child: Text("Seller Dashboard")),
              ); // Placeholder
            }
          },
        );
      },
    );
  }
}
