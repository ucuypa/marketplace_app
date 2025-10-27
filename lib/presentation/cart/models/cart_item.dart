import 'package:flutter/foundation.dart';
import '../../home/models/product.dart';

@immutable
class CartItem {
  final Product product;
  final String size;   // contoh: 'L' atau '40'
  final String color;  // label warna: 'Blue', 'Black', dst.
  final int qty;

  const CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.qty = 1,
  });

  double get unitPrice => product.price;
  double get lineTotal => unitPrice * qty;

  // buat key unik per kombinasi product + varian
  String get key => '${product.id}::$size::$color';

  CartItem copyWith({int? qty}) =>
      CartItem(product: product, size: size, color: color, qty: qty ?? this.qty);
}
