import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController(text: 'Ahua');
  final TextEditingController emailController = TextEditingController(text: 'ahua@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kScaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {},
          )
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
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: dp(ctx, 50),
                            backgroundImage: const AssetImage('assets/image/profile_placeholder.png'),
                          ),
                          Container(
                            width: dp(ctx, 32),
                            height: dp(ctx, 32),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: dp(ctx, 16)),
                    const Center(
                      child: Text(
                        'Nahida Gaming',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: dp(ctx, 32)),
                    _buildTextField('Full Name', nameController, ctx),
                    SizedBox(height: dp(ctx, 20)),
                    _buildTextField('Email Address', emailController, ctx),
                    SizedBox(height: dp(ctx, 20)),
                    _buildTextField('Password', passwordController, ctx, obscure: true),
                    SizedBox(height: dp(ctx, 40)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.symmetric(vertical: dp(ctx, 16)),
                      ),
                      onPressed: () {},
                      child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, BuildContext ctx, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        SizedBox(height: dp(ctx, 8)),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: dp(ctx, 16), horizontal: dp(ctx, 16)),
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
