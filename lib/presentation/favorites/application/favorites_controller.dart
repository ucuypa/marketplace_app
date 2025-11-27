import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/models/product.dart';

class FavoritesController extends ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  FavoritesController() {
    _initFavorites();
  }

  void _initFavorites() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Listen to user_favorite collection
    FirebaseFirestore.instance
        .collection('user_favorite')
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
          _items = snapshot.docs.map((doc) {
            final data = doc.data();
            // Reconstruct basic product info for display
            return Product(
              id: data['itemID'],
              title: data['title'],
              price: (data['price'] as num).toDouble(),
              imageAsset: data['image'] ?? '',
              description: '',
              sellerID: '',
              // Store the Firestore doc ID temporarily in 'badge' or handle separately if needed
              // For simple display, this is enough.
            );
          }).toList();
          notifyListeners();
        });
  }

  Future<void> toggleFavorite(Product p) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final collection = FirebaseFirestore.instance.collection('user_favorite');

    // Check if already favorited
    final query = await collection
        .where('userID', isEqualTo: user.uid)
        .where('itemID', isEqualTo: p.id)
        .get();

    if (query.docs.isNotEmpty) {
      // REMOVE
      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } else {
      // ADD
      await collection.add({
        'userID': user.uid,
        'itemID': p.id,
        'title': p.title,
        'price': p.price,
        'image': p.imageAsset,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Check if a specific product is favorite (helper for UI icons)
  bool isFavorite(String productId) {
    return _items.any((item) => item.id == productId);
  }
}
