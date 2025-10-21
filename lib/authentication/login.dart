import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- IMPORTANT ---
// You need to create these screens yourself.
// For now, just create empty StatefulWidget files for them
// so this code doesn't show an error.
//
// import 'buyer_home_screen.dart';
// import 'seller_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      // 1. Sign In with Firebase Auth
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("Login failed, please try again.");
      }

      final String uid = firebaseUser.uid;

      // 2. Get User Role from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception("User data not found. Please contact support.");
      }

      final String userRole = userDoc.get('role');

      // 3. Navigate based on Role
      if (mounted) {
        if (userRole == 'buyer') {
          // Navigate to Buyer Home
          /*
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BuyerHomeScreen()),
          );
          */
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer Login Successful!')),
          );
        } else if (userRole == 'seller') {
          // Navigate to Seller Dashboard
          /*
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SellerDashboardScreen()),
          );
          */
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Seller Login Successful!')),
          );
        } else {
          throw Exception("Unknown user role.");
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific auth errors
      String message = 'An error occurred. Please check your credentials.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid credentials. Please check your email and password.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      // Handle other errors (like Firestore fetch error)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
            // TODO: Add a "Don't have an account? Sign Up" button
            // to navigate to your RegistrationScreen
          ],
        ),
      ),
    );
  }
}
