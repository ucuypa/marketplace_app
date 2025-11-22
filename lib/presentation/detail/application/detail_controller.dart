import 'package:flutter/material.dart';
import '../../home/models/product.dart';

class DetailController extends ChangeNotifier {
  final Product product;

  String? _selectedSize;

  DetailController(this.product) {
    // Automatically select the first available size if any exist
    if (product.sizes.isNotEmpty) {
      _selectedSize = product.sizes.first;
    }
  }

  // 1. Category Title
  String get categoryTitle => product.category;

  // 2. Available Sizes
  List<String> get sizes => product.sizes;

  // 3. Currently Selected Size
  String? get selectedSize => _selectedSize;

  // ⭐️ 4. NEW: Get Stock for the selected size
  int get stockForSelectedSize {
    if (_selectedSize == null) return 0;
    // Look up the size in the inventory map. Default to 0 if not found.
    return product.inventory[_selectedSize] ?? 0;
  }

  // 5. Setter for Size
  void setSize(String v) {
    if (v == _selectedSize) return;
    _selectedSize = v;
    notifyListeners();
  }

  // unused color logic
  String get selectedColor => '';
  void setColor(String v) {}
}
