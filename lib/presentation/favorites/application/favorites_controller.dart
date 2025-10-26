import 'package:flutter/material.dart';
import '../../home/models/product.dart';

class FavoritesController extends ChangeNotifier {
  final Map<String, Product> _items = {}; // id -> product

  List<Product> get items => _items.values.toList(growable: false);
  bool isFavorite(Product p) => _items.containsKey(p.id);

  void toggle(Product p) {
    if (isFavorite(p)) {
      _items.remove(p.id);
    } else {
      _items[p.id] = p;
    }
    notifyListeners();
  }
}
