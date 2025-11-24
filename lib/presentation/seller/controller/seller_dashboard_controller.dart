// lib/presentation/seller/seller_dashboard_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/seller_dashboard_model.dart';

class SellerDashboardController {
  final auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SellerDashboardController({
    auth.FirebaseAuth? authInstance,
    FirebaseFirestore? firestore,
  })  : _auth = authInstance ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<SellerDashboardData> fetchDashboardData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    final userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      throw Exception('User document not found');
    }

    final data = userDoc.data() as Map<String, dynamic>;
// ================== INI BAGIAN YANG DIGANTI ==================
    // Ambil produk milik seller dari koleksi "items"
    final itemsSnapshot = await _firestore
        .collection('items')
        .where('sellerID', isEqualTo: user.uid)
        .get();

    final products = itemsSnapshot.docs
        .map((doc) => SellerProduct.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ))
        .toList();

    final productCount = itemsSnapshot.size;
    // ============================================================

    return SellerDashboardData(
      storeName: data['storeName'] ?? '',
      storeAddress: data['storeAddress'] ?? '',
      rating: (data['rating'] ?? 4.8).toDouble(),      // default contoh
      salesCount: (data['salesCount'] ?? 0) as int,
      productCount: productCount,
      storeAvatarUrl: data['profilePicUrl'],
      products: products,
    );
  }

  Future<void> updateStoreInfo({
    required String storeName,
    required String storeAddress,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'storeName': storeName,
      'storeAddress': storeAddress,
    });
  }
}
