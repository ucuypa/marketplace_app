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
  // Text editing controllers (Added _nameController)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // The currently selected role
  UserRole _selectedRole = UserRole.buyer; // Default to Buyer

  // Loading state
  bool _isLoading = false;

  // Added for password visibility
  bool _isPasswordObscured = true;

  // The main sign-up function (Updated to include name)
  Future<void> _signUp() async {
    if (mounted) setState(() => _isLoading = true);

    // Get text from controllers
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Simple validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      // 1. Create User with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("User creation failed, please try again.");
      }

      final String uid = firebaseUser.uid;

      // 2. Save User Role and Name to Cloud Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name, // <-- Added name
        'email': email,
        'role': _selectedRole == UserRole.buyer ? 'buyer' : 'seller',
        'createdAt': Timestamp.now(),
      });

      // 3. (Optional) Navigate to Home Screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        // Pop back to the login screen after successful registration
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Responsive Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // --- Header Text ---
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Let's Create Account Together",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 48),

                          // --- Your Name Field ---
                          _buildTextFieldLabel('Your Name'),
                          TextFormField(
                            controller: _nameController,
                            decoration: _buildInputDecoration(
                              hintText: 'Your Name',
                              icon: Icons.person_outline,
                            ),
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),

                          // --- Email Field ---
                          _buildTextFieldLabel('Email Address'),
                          TextFormField(
                            controller: _emailController,
                            decoration: _buildInputDecoration(
                              hintText: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // --- Password Field ---
                          _buildTextFieldLabel('Password'),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isPasswordObscured,
                            decoration:
                                _buildInputDecoration(
                                  hintText: '••••••••',
                                  icon: Icons.lock_outline,
                                ).copyWith(
                                  // Add suffix icon for visibility
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[500],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured =
                                            !_isPasswordObscured;
                                      });
                                    },
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24),

                          // Role Selector
                          _buildTextFieldLabel('Account Type'),
                          SizedBox(
                            width: double.infinity,
                            // Use SegmentedButton for a modern role selector
                            child: SegmentedButton<UserRole>(
                              segments: const [
                                ButtonSegment<UserRole>(
                                  value: UserRole.buyer,
                                  label: Text('Buyer'),
                                  icon: Icon(Icons.shopping_bag_outlined),
                                ),
                                ButtonSegment<UserRole>(
                                  value: UserRole.seller,
                                  label: Text('Seller'),
                                  icon: Icon(Icons.storefront_outlined),
                                ),
                              ],
                              selected: {_selectedRole},
                              onSelectionChanged: (Set<UserRole> newSelection) {
                                setState(() {
                                  _selectedRole = newSelection.first;
                                });
                              },
                              style: SegmentedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0D63F8),
                                selectedForegroundColor: Colors.white,
                                selectedBackgroundColor: const Color(
                                  0xFF0D63F8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Button Sign Up
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _signUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0D63F8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20), // Extra space
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
                        "Already Have An Account? ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D63F8),
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

  // Helper widget for text field labels
  Widget _buildTextFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper method for consistent text field styling
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      fillColor: Colors.white,
      filled: true,
      prefixIcon: Icon(icon, color: Colors.grey[500]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
