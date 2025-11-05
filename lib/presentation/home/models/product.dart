import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⬅️ 1. Tambahkan import ini

/// Closed set of categories → type-safe & compiler-checked (no mistyped strings).
enum Category { all, mensTShirt, mensShoes, limited }

/// Mark the class as immutable:
/// - Communicates intent: instances should not change after creation
/// - Works nicely with Provider/Riverpod because immutable data makes rebuilds predictable
@immutable
class Product {
  final String id;
  final String title;
  final double price;
  final String imageAsset;
  final String badge;
  final bool isPopular;
  final List<Category> categories;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageAsset,
    this.badge = '',
    this.isPopular = false,
    this.categories = const [Category.mensTShirt],
    this.description = '',
  });

  String get priceText => '\$${price.toStringAsFixed(2)}';

  /// Factory constructor untuk membuat Product dari dokumen Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // --- Logika untuk mem-parsing 'tags' dari database ---
    List<String> tags = List<String>.from(data['tags'] ?? []);
    bool isPopular = tags.contains('popular');
    String badge;
    try {
      // Coba temukan tag pertama yang BUKAN 'popular' sebagai badge
      badge = tags.firstWhere((tag) => tag != 'popular');
    } catch (e) {
      badge = ''; // Tidak ada badge
    }

    // --- Kembalikan objek Product ---
    return Product(
      id: doc.id,
      title: data['name'] ?? 'Untitled', // Map 'name' -> 'title'
      price: (data['price'] ?? 0.0).toDouble(),
      imageAsset:
          data['previewImageUrl'] ??
          '', // Map 'previewImageUrl' -> 'imageAsset'
      description: data['description'] ?? '',
      badge: badge,
      isPopular: isPopular,

      // Biarkan kosong untuk daftar, halaman detail harus mengambil kategorinya sendiri
      categories: [],
    );
  }
}
