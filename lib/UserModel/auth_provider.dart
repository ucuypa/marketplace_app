import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

// 1. A provider that just gives us the current Firebase User
final authUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

// 2. The main provider that gives us our app's UserModel (from Firestore)
final userModelProvider = StreamProvider<UserModel?>((ref) {
  // Watch the Firebase User provider
  final authUser = ref.watch(authUserProvider).value;

  if (authUser == null) {
    // User is logged out
    return Stream.value(null);
  }

  // User is logged in, listen to their Firestore document
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(authUser.uid);

  // Return a stream that maps the Firestore document to our UserModel
  return docRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot);
    }
    return null; // Document doesn't exist (this shouldn't happen)
  });
});
