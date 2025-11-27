import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Product {
  final String id;
  final String sellerID; // ⬅️ ADDED THIS
  final String title;
  final double price;
  final String imageAsset;
  final String badge;
  final bool isPopular;
  final String description;
  final String category;
  final List<String> sizes;
  final int stock;
  final Map<String, dynamic> inventory;

  const Product({
    required this.id,
    required this.sellerID, // ⬅️ ADDED THIS
    required this.title,
    required this.price,
    required this.imageAsset,
    this.badge = '',
    this.isPopular = false,
    this.description = '',
    this.category = 'Product',
    this.sizes = const [],
    this.stock = 0,
    this.inventory = const {},
  });

  String get priceText => '\$${price.toStringAsFixed(2)}';

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // Helper to parse tags safely
    List<String> tags = List<String>.from(data['tags'] ?? []);
    bool isPopular = tags.contains('popular');
    String badge = '';
    if (tags.isNotEmpty) {
      try {
        badge = tags.firstWhere((tag) => tag != 'popular');
      } catch (_) {}
    }

    return Product(
      id: doc.id,
      // ⭐️ MAP THE SELLER ID (Defaults to empty string if missing)
      sellerID: data['sellerID'] ?? '',

      title: data['name'] ?? 'Untitled',
      price: (data['price'] ?? 0.0).toDouble(),
      imageAsset: data['previewImageUrl'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      sizes: List<String>.from(data['sizes'] ?? []),
      stock: data['stock'] ?? 0,
      inventory: data['inventory'] ?? {},
      badge: badge,
      isPopular: isPopular,
    );
  }
}
