import 'package:flutter/foundation.dart';

enum Category { all, mensTShirt, mensShoes, limited }

@immutable
class Product {
  final String id;
  final String title;
  final double price;
  final String imageAsset;
  final String badge;
  final bool isPopular;
  final List<Category> categories;

  // ⬇️ NEW
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageAsset,
    this.badge = '',
    this.isPopular = false,
    this.categories = const [Category.mensTShirt],
    // ⬇️ NEW (default aman)
    this.description = '',
  });

  String get priceText => '\$${price.toStringAsFixed(2)}';
}
