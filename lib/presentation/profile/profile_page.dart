import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import '../manageproduct/ManageProductsPage.dart';
import '../address_user/address_page.dart';
import '../seller/seller_dashboard_page.dart'; // SESUAIKAN PATH

// widgets
import 'widgets/profile_header_section.dart';
import 'widgets/profile_editable_field.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_seller_section.dart';  // <-- NEW

// controller
import 'controller/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController(); // <-- NEW

  late final ProfileController _controller;

  bool _isLoading = true;
  bool _isEditing = false;
  String? _profilePicUrl;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _fetchUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    storeNameController.dispose(); // <-- NEW
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _controller.fetchUserData();

      nameController.text = data.name;
      passwordController.text = '********';
      storeNameController.text = data.storeName ?? ''; // <-- NEW

      setState(() {
        _profilePicUrl = data.profilePicUrl;
        _userRole = data.role;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to load profile: ${e.toString()}');
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await _controller.saveProfile(
        name: nameController.text,
        password: passwordController.text,
        storeName: storeNameController.text, // <-- NEW
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }

      setState(() {
        _isEditing = false;
      });
      passwordController.text = '********';
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

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadProfilePicture() async {
    setState(() => _isLoading = true);
    try {
      final String? url = await _controller.uploadProfilePicture();
      if (url != null) {
        setState(() {
          _profilePicUrl = url;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Failed to upload image: ${e.toString()}');
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await _controller.signOut();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to sign out: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
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
                  ),
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
                          // 1. HEADER
                          ProfileHeaderSection(
                            profilePicUrl: _profilePicUrl,
                            displayName: nameController.text,
                            isEditing: _isEditing,
                            onChangePhoto: _uploadProfilePicture,
                          ),

                          SizedBox(height: dp(ctx, 32)),

                          // 2. FIELDS
                          ProfileEditableField(
                            label: 'Full Name',
                            controller: nameController,
                            isEditing: _isEditing,
                          ),
                          SizedBox(height: dp(ctx, 20)),
                          ProfileEditableField(
                            label: 'Password',
                            controller: passwordController,
                            isEditing: _isEditing,
                            obscure: true,
                            hint: 'Enter new password (optional)',
                          ),

                          SizedBox(height: dp(ctx, 24)),
                          const Divider(thickness: 1, color: Color(0xFFEAEAEA)),
                          SizedBox(height: dp(ctx, 16)),

                          // 3. SELLER SECTION (only for seller)
                          if (_userRole == 'seller') ...[
                            ProfileSellerSection(
                              storeNameController: storeNameController,
                              isEditing: _isEditing,
                              onGoToDashboard: () {
                                // sementara pakai ManageProductPage sebagai dashboard
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SellerDashboardPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: dp(ctx, 24)),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFEAEAEA),
                            ),
                            SizedBox(height: dp(ctx, 16)),
                          ],

                          // 4. MENU ITEMS
                          ProfileMenuItem(
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
                              child: ProfileMenuItem(
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
}
