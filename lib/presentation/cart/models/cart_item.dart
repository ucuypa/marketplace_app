import 'package:flutter/foundation.dart';
import '../../home/models/product.dart';

class CartItem {
  final String? id;
  final Product product;
  final int qty;
  final String size;

  CartItem({this.id, required this.product, this.qty = 1, required this.size});

  String get key => '${product.id}_$size';
  double get lineTotal => product.price * qty;

  CartItem copyWith({int? qty}) {
    return CartItem(id: id, product: product, size: size, qty: qty ?? this.qty);
  }
}
