import 'package:flutter/material.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController =
  TextEditingController(text: 'Ahua');
  final TextEditingController emailController =
  TextEditingController(text: 'ahua@gmail.com');
  final TextEditingController passwordController =
  TextEditingController(text: '12345678');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.edit, color: Colors.blueAccent),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final s = calcScale(c);
            return Scale(
              s: s,
              child: Builder(
                builder: (ctx) => ListView(
                  padding: EdgeInsets.all(dp(ctx, 24)),
                  children: [
                    // ===== Avatar =====
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: dp(ctx, 50),
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/image/profile_placeholder.png',
                                width: dp(ctx, 100),
                                height: dp(ctx, 100),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.person, size: dp(ctx, 48)),
                              ),
                            ),
                          ),
                          Container(
                            width: dp(ctx, 32),
                            height: dp(ctx, 32),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: dp(ctx, 16)),

                    // ===== Display name =====
                    Center(
                      child: Text(
                        'Nahida Gaming',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: dp(ctx, 32)),

                    // ===== Fields (READ-ONLY) =====
                    _readOnlyField('Full Name', nameController, ctx),
                    SizedBox(height: dp(ctx, 20)),
                    _readOnlyField('Email Address', emailController, ctx),
                    SizedBox(height: dp(ctx, 20)),
                    _readOnlyField('Password', passwordController, ctx,
                        obscure: true),

                    SizedBox(height: dp(ctx, 40)),

                    // ===== Button: Manage Products =====
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding:
                          EdgeInsets.symmetric(vertical: dp(ctx, 16)),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (_) => const ManageProductsPage()),
                          // );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Manage Products page belum tersedia')),
                          );
                        },
                        child: const Text(
                          'Manage Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==== helper widget ====
  Widget _readOnlyField(
      String label,
      TextEditingController controller,
      BuildContext ctx, {
        bool obscure = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        SizedBox(height: dp(ctx, 8)),
        TextField(
          controller: controller,
          obscureText: obscure,
          enabled: false,
          readOnly: true,
          style: const TextStyle(
            color: Colors.black, // <- teks di field jadi hitam normal
            fontSize: 16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: dp(ctx, 16),
              horizontal: dp(ctx, 16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
