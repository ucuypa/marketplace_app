import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import '../manageproduct/ManageProductsPage.dart';
import '../address_user/address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = true;
  bool _isEditing = false;
  String? _profilePicUrl;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      final auth.User? user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        passwordController.text = '********';
        _profilePicUrl = data['profilePicUrl'];
        _userRole = data['role'];
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load profile: ${e.toString()}');
    }
    setState(() => _isLoading = false);
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final auth.User? user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user");

      final newName = nameController.text;
      final newPassword = passwordController.text;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': newName},
      );

      if (newPassword.isNotEmpty && newPassword != '********') {
        await user.updatePassword(newPassword);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showErrorSnackbar(
          'Requires recent login. Please log out and log in again.',
        );
      } else {
        _showErrorSnackbar('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to save profile: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
      _isEditing = false;
      passwordController.text = '********';
    });
  }

  Future<void> _uploadProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isLoading = true);
    final String uid = auth.FirebaseAuth.instance.currentUser!.uid;

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uid.jpg');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      if (kIsWeb) {
        final Uint8List imageBytes = await image.readAsBytes();
        await storageRef.putData(imageBytes, metadata);
      } else {
        final File imageFile = File(image.path);
        await storageRef.putFile(imageFile, metadata);
      }

      final String downloadURL = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePicUrl': downloadURL,
      });

      setState(() {
        _profilePicUrl = downloadURL;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to upload image: ${e.toString()}');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kScaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isEditing
              ? TextButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.blueAccent,
                  ), // Pencil icon
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                      passwordController.clear();
                    });
                  },
                ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final s = calcScale(c);
                  return Scale(
                    s: s,
                    child: Builder(
                      builder: (ctx) => ListView(
                        padding: EdgeInsets.all(dp(ctx, 24)),
                        children: [
                          // ===== 1. PROFILE PICTURE =====
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: dp(ctx, 50),
                                  backgroundColor: Colors.white,
                                  child: _profilePicUrl == null
                                      ? Icon(
                                          Icons.person,
                                          size: dp(ctx, 48),
                                          color: Colors.grey,
                                        )
                                      : ClipOval(
                                          child: Image.network(
                                            _profilePicUrl!,
                                            width: dp(ctx, 100),
                                            height: dp(ctx, 100),
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  progress,
                                                ) => progress == null
                                                ? child
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: dp(ctx, 48),
                                            ),
                                          ),
                                        ),
                                ),
                                Visibility(
                                  visible: _isEditing,
                                  child: GestureDetector(
                                    onTap: _uploadProfilePicture,
                                    child: Container(
                                      width: dp(ctx, 32),
                                      height: dp(ctx, 32),
                                      decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: dp(ctx, 12)),
                          Center(
                            child: Text(
                              nameController.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          SizedBox(height: dp(ctx, 32)),

                          _editableField('Full Name', nameController, ctx),
                          SizedBox(height: dp(ctx, 20)),
                          _editableField(
                            'Password',
                            passwordController,
                            ctx,
                            obscure: true,
                            hint: 'Enter new password (optional)',
                          ),

                          SizedBox(height: dp(ctx, 24)),
                          const Divider(thickness: 1, color: Color(0xFFEAEAEA)),
                          SizedBox(height: dp(ctx, 16)),
                          _menuItem(
                            ctx,
                            title: 'Manage Address',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddressListPage(),
                                ),
                              );
                            },
                          ),

                          if (_userRole == 'seller')
                            Padding(
                              padding: EdgeInsets.only(top: dp(ctx, 16)),
                              child: _menuItem(
                                ctx,
                                title: 'Manage Product',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ManageProductPage(),
                                    ),
                                  );
                                },
                              ),
                            ),

                          SizedBox(height: dp(ctx, 60)),
                          Center(
                            child: TextButton(
                              onPressed: _signOut,
                              child: const Text(
                                'Log out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: dp(ctx, 20)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _editableField(
    String label,
    TextEditingController controller,
    BuildContext ctx, {
    bool obscure = false,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: dp(ctx, 8)),
        TextField(
          controller: controller,
          obscureText: obscure,
          enabled: _isEditing,
          readOnly: !_isEditing,
          decoration: InputDecoration(
            hintText: _isEditing ? hint : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: dp(ctx, 16),
              horizontal: dp(ctx, 16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext ctx, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: dp(ctx, 12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
