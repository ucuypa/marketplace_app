import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registration.dart';
import 'package:marketplace_app/presentation/home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Password visibility toggle
  bool _isPasswordObscured = true;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
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
      // Handle other errors
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

  // Responsive Build Methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        // 1. Center the content for web/desktop
        child: Center(
          // 2. Constrain the max width for web/desktop
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            // 3. Use Column to hold the form and the footer
            child: Column(
              children: [
                // 4. Use Expanded + SingleChildScrollView for the form
                // This makes the form scrollable and pushes the footer down
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // Header Text
                          const Text(
                            'Hello Again!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Welcome Back You've Been Missed!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Email Field
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey[500],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none, // No border
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText:
                                _isPasswordObscured, // Use state variable
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey[500],
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[500],
                                ),
                                // Toggle password visibility
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                /* TODO: Implement Forgot Password */
                              },
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Color(0xFF0D63F8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign In Button
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity, // Stretch to fill
                                  height: 50,
                                  child: ElevatedButton(
                                    // login function
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0D63F8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),

                // footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have An Account? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up For Free',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D63F8), // Matching blue
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
