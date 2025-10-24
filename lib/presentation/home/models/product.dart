import 'package:flutter/foundation.dart';

enum Category { all, mensTShirt, mensShoes, specialPrice }

@immutable
class Product {
  final String id;
  final String title;
  final double price;
  final String imageAsset;
  final String badge;
  final bool isPopular;
  final Category category; // ⬅️ baru

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageAsset,
    this.badge = '',
    this.isPopular = false,
    this.category = Category.mensTShirt, // default aman
  });

  String get priceText => '\$${price.toStringAsFixed(2)}';
}
