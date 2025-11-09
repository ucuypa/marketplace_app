import 'package:flutter/material.dart';
import '../../home/models/product.dart';

class DetailController extends ChangeNotifier {
  final Product product;

  late String _selectedColor;
  late String _selectedSize;

  DetailController(this.product) {
    _selectedSize = sizes.first;
  }

  String get categoryTitle {
    if (product.categories.contains(Category.mensShoes)) return "Men's Shoes";
    if (product.categories.contains(Category.mensTShirt))
      return "Men's T-Shirt";
    return 'Details';
  }

  // --- sizes dinamis berdasar kategori
  List<String> get sizes => product.categories.contains(Category.mensShoes)
      ? const ['38', '39', '40', '41', '42', '43']
      : const ['S', 'M', 'L', 'XL'];

  String get selectedColor => _selectedColor;
  String get selectedSize => _selectedSize;

  void setColor(String v) {
    if (v == _selectedColor) return;
    _selectedColor = v;
    notifyListeners();
  }

  void setSize(String v) {
    if (v == _selectedSize) return;
    _selectedSize = v;
    notifyListeners();
  }
}
