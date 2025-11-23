// lib/presentation/profile/controller/profile_controller.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:image_picker/image_picker.dart';

class ProfileUserData {
  final String name;
  final String? profilePicUrl;
  final String? role;
  final String? storeName;          // <-- NEW

  ProfileUserData({
    required this.name,
    this.profilePicUrl,
    this.role,
    this.storeName,                 // <-- NEW
  });
}

class ProfileController {
  final auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileController({
    auth.FirebaseAuth? authInstance,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = authInstance ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<ProfileUserData> fetchUserData() async {
    final auth.User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      throw Exception("User document not found");
    }

    final data = userDoc.data() as Map<String, dynamic>;

    return ProfileUserData(
      name: data['name'] ?? '',
      profilePicUrl: data['profilePicUrl'],
      role: data['role'],
      storeName: data['storeName'],  // <-- NEW
    );
  }

  Future<void> saveProfile({
    required String name,
    required String password,
    required String storeName,      // <-- NEW
  }) async {
    final auth.User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user");
    }

    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      'storeName': storeName,       // <-- NEW
    });

    if (password.isNotEmpty && password != '********') {
      await user.updatePassword(password);
    }
  }

  Future<String?> uploadProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final String uid = _auth.currentUser!.uid;

    final Reference storageRef =
        _storage.ref().child('profile_pictures').child('$uid.jpg');

    final metadata = SettableMetadata(contentType: 'image/jpeg');

    if (kIsWeb) {
      final Uint8List imageBytes = await image.readAsBytes();
      await storageRef.putData(imageBytes, metadata);
    } else {
      final File imageFile = File(image.path);
      await storageRef.putFile(imageFile, metadata);
    }

    final String downloadURL = await storageRef.getDownloadURL();

    await _firestore.collection('users').doc(uid).update({
      'profilePicUrl': downloadURL,
    });

    return downloadURL;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
