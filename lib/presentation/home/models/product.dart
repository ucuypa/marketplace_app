import 'package:flutter/foundation.dart';
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
}
