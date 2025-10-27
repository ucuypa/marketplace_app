import 'package:flutter/foundation.dart';
import 'package:marketplace_app/presentation/home/models/product.dart';
import 'package:marketplace_app/presentation/cart/models/cart_item.dart';


class CartController extends ChangeNotifier {
  // key -> CartItem
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  void add(Product p, {required String size, required String color, int qty = 1}) {
    final tmp = CartItem(product: p, size: size, color: color, qty: qty);
    final k = tmp.key;
    if (_items.containsKey(k)) {
      final curr = _items[k]!;
      _items[k] = curr.copyWith(qty: curr.qty + qty);
    } else {
      _items[k] = tmp;
    }
    notifyListeners();
  }

  void inc(CartItem it) {
    _items[it.key] = it.copyWith(qty: it.qty + 1);
    notifyListeners();
  }

  void dec(CartItem it) {
  final k = it.key;
  final curr = _items[k];
  if (curr == null) return;

  // ⬇️ Jangan boleh kurang dari 1
  if (curr.qty > 1) {
    _items[k] = curr.copyWith(qty: curr.qty - 1);
    notifyListeners();
  }
  // else: do nothing (tetap 1)
}

  void remove(CartItem it) {
    _items.remove(it.key);
    notifyListeners();
  }

  double get subtotal =>
      _items.values.fold(0.0, (sum, it) => sum + it.lineTotal);

  // Contoh sederhana: flat shipping $10 kalau ada item
  double get shipping => items.isEmpty ? 0.0 : 10.0;

  double get total => subtotal + shipping;
}
