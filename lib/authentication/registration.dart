import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// An enum to make role selection cleaner
enum UserRole { buyer, seller }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // The currently selected role
  UserRole _selectedRole = UserRole.buyer; // Default to Buyer

  // Loading state
  bool _isLoading = false;

  // The main sign-up function
  Future<void> _signUp() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      // 1. Create User with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Check if user was created and get the UID
      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("User creation failed, please try again.");
      }

      final String uid = firebaseUser.uid;

      // 2. Save User Role to Cloud Firestore
      // We use .doc(uid) to set the document ID to be the same as the auth UID
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': _emailController.text.trim(),
        'role': _selectedRole == UserRole.buyer
            ? 'buyer'
            : 'seller', // Store role as a string
        'createdAt': Timestamp.now(),
        // Add other fields you want, like 'name', 'profilePicUrl', etc.
      });

      // 3. (Optional) Navigate to Home Screen
      if (mounted) {
        // You can check the role and navigate to the correct dashboard
        if (_selectedRole == UserRole.buyer) {
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BuyerHomeScreen()));
        } else {
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SellerDashboard()));
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., email-already-in-use, weak-password)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "An error occurred")),
        );
      }
    } catch (e) {
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
      appBar: AppBar(title: const Text("Create Account")),
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
            const SizedBox(height: 20),
            // --- This is the Role Selector ---
            const Text(
              "Select your account type:",
              style: TextStyle(fontSize: 16),
            ),
            RadioListTile<UserRole>(
              title: const Text('Buyer (I want to buy themes)'),
              value: UserRole.buyer,
              groupValue: _selectedRole,
              onChanged: (UserRole? value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            RadioListTile<UserRole>(
              title: const Text('Seller (I want to sell themes)'),
              value: UserRole.seller,
              groupValue: _selectedRole,
              onChanged: (UserRole? value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            // ---------------------------------
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}
