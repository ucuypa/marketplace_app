import 'package:flutter/material.dart';
// ⬅️ Import-import yang diperlukan untuk Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;

// import '../manage_products/manage_products_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ⬅️ Controller-controller sekarang diinisialisasi kosong
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ⬅️ State variables untuk logic UI
  bool _isLoading = true; // Untuk loading data awal & saat menyimpan
  bool _isEditing = false; // Untuk toggle mode edit
  String? _profilePicUrl; // Untuk menyimpan URL gambar profil
  String? _userRole; // Untuk Cek role 'seller'

  @override
  void initState() {
    super.initState();
    // ⬅️ Ambil data pengguna saat halaman dimuat
    _fetchUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ===== (R)EAD: Mengambil Data Pengguna =====
  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in");
      }

      // Ambil data dari Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        // ⬅️ Set data ke controllers dan state
        nameController.text = data['name'] ?? '';
        emailController.text = user.email ?? ''; // Ambil dari Auth lebih aman
        passwordController.text = '********'; // Placeholder
        _profilePicUrl = data['profilePicUrl'];
        _userRole = data['role'];
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load profile: ${e.toString()}');
    }
    setState(() => _isLoading = false);
  }

  // ===== (U)PDATE: Menyimpan Perubahan Profil =====
  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    // Sembunyikan keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user");

      final newName = nameController.text;
      final newEmail = emailController.text;
      final newPassword = passwordController.text;

      // 1. Update Nama di Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': newName},
      );

      // 2. Update Password di Auth (jika diisi)
      if (newPassword.isNotEmpty && newPassword != '********') {
        await user.updatePassword(newPassword);
      }

      // Selesai
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showErrorSnackbar(
          'This operation is sensitive and requires recent login. Please log out and log in again.',
        );
      } else {
        _showErrorSnackbar('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to save profile: ${e.toString()}');
    }

    // ⬅️ Kembalikan ke mode read-only
    setState(() {
      _isLoading = false;
      _isEditing = false;
      passwordController.text = '********'; // Reset placeholder
    });
  }

  // ===== (C)REATE/(U)PDATE: Upload Foto Profil (Multiplatform) =====
  Future<void> _uploadProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // User membatalkan

    setState(() => _isLoading = true);
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // 1. Buat referensi di Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uid.jpg');

      // 2. Upload file (CARA BERBEDA UNTUK WEB DAN MOBILE)
      if (kIsWeb) {
        // --- UNTUK WEB ---
        // Ambil data gambar sebagai bytes
        final Uint8List imageBytes = await image.readAsBytes();
        // Upload menggunakan putData
        await storageRef.putData(imageBytes);
      } else {
        // --- UNTUK MOBILE / DESKTOP ---
        // Ambil file dari path
        final File imageFile = File(image.path);
        // Upload menggunakan putFile
        await storageRef.putFile(imageFile);
      }

      // 3. Dapatkan URL download (Sama untuk keduanya)
      final String downloadURL = await storageRef.getDownloadURL();

      // 4. Update URL di Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePicUrl': downloadURL,
      });

      // 5. Update UI secara lokal
      setState(() {
        _profilePicUrl = downloadURL;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to upload image: ${e.toString()}');
    }
    setState(() => _isLoading = false);
  }

  // ===== Helper untuk menampilkan error =====
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
        actions: [
          // ⬅️ Tombol Edit/Save yang bisa berubah
          _isEditing
              ? TextButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                      passwordController
                          .clear(); // ⬅️ Kosongkan field password saat edit
                    });
                  },
                ),
        ],
      ),
      // ⬅️ Tampilkan loading spinner saat memuat data atau menyimpan
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
                          // ===== Avatar =====
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: dp(ctx, 50),
                                  backgroundColor: Colors.white,
                                  // ⬅️ Tampilkan gambar dari URL
                                  child: _profilePicUrl == null
                                      ? Icon(Icons.person, size: dp(ctx, 48))
                                      : ClipOval(
                                          child: Image.network(
                                            _profilePicUrl!,
                                            width: dp(ctx, 100),
                                            height: dp(ctx, 100),
                                            fit: BoxFit.cover,
                                            // ⬅️ Tampilkan loading saat gambar dimuat
                                            loadingBuilder:
                                                (context, child, progress) {
                                                  return progress == null
                                                      ? child
                                                      : const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                },
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: dp(ctx, 48),
                                            ),
                                          ),
                                        ),
                                ),
                                // ⬅️ Tombol ganti foto, hanya muncul saat mode edit
                                Visibility(
                                  visible: _isEditing,
                                  child: GestureDetector(
                                    onTap:
                                        _uploadProfilePicture, // ⬅️ Panggil fungsi upload
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

                          SizedBox(height: dp(ctx, 16)),
                          // ===== Display name besar (dinamis) =====
                          Center(
                            child: Text(
                              // ⬅️ Ambil dari controller agar dinamis
                              nameController.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          SizedBox(height: dp(ctx, 32)),
                          // ===== Fields (sekarang bisa diedit) =====
                          _editableField('Full Name', nameController, ctx),
                          SizedBox(height: dp(ctx, 20)),
                          _editableField(
                            'Password',
                            passwordController,
                            ctx,
                            obscure: true,
                            hint:
                                'Enter new password (optional)', // ⬅️ Hint untuk password
                          ),

                          SizedBox(height: dp(ctx, 40)),
                          // ===== Button: Manage Products (bersyarat) =====
                          // ⬅️ Hanya tampil jika role adalah 'seller'
                          Visibility(
                            visible: _userRole == 'seller',
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: dp(ctx, 16),
                                  ),
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (_) => const ManageProductsPage()),
                                  // );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Manage Products page belum tersedia',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Manage Products',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  // ==== helper widget yang dimodifikasi ====
  Widget _editableField(
    String label,
    TextEditingController controller,
    BuildContext ctx, {
    bool obscure = false,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(height: dp(ctx, 8)),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          // ⬅️ Ini adalah kunci untuk mode edit
          enabled: _isEditing,
          readOnly: !_isEditing,
          decoration: InputDecoration(
            hintText: _isEditing
                ? hint
                : null, // ⬅️ Tampilkan hint hanya saat edit
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
            // ⬅️ Ubah style saat disabled
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
