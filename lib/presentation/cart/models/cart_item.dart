import 'package:flutter/foundation.dart';
import '../../home/models/product.dart';

@immutable
class CartItem {
  final Product product;
  final String size; // contoh: 'L' atau '40'
  final int qty;

  const CartItem({required this.product, required this.size, this.qty = 1});

  double get unitPrice => product.price;
  double get lineTotal => unitPrice * qty;

  // buat key unik per kombinasi product + varian
  String get key => '${product.id}::$size::';

  CartItem copyWith({int? qty}) =>
      CartItem(product: product, size: size, qty: qty ?? this.qty);
}
