import 'package:flutter/material.dart';
import '../../home/models/product.dart';
import '../widgets/color_selector.dart'; // pakai tipe ColorOption biar simpel

class DetailController extends ChangeNotifier {
  final Product product;

  // --- color options (bisa diambil dari repo nanti)
  final List<ColorOption> colorOptions = const [
    ColorOption('Blue',  Color(0xFF5B9EE1)),
    ColorOption('Black', Color(0xFF222222)),
    ColorOption('White', Color(0xFFFFFFFF), border: Color(0xFFDEE2E6)),
  ];

  late String _selectedColor;
  late String _selectedSize;

  DetailController(this.product) {
    _selectedColor = colorOptions.first.label;
    _selectedSize  = sizes.first;
  }
  
  

  String get categoryTitle {
    if (product.categories.contains(Category.mensShoes)) return "Men's Shoes";
    if (product.categories.contains(Category.mensTShirt)) return "Men's T-Shirt";
    return 'Details';
  }


  // --- sizes dinamis berdasar kategori
  List<String> get sizes => product.categories.contains(Category.mensShoes)
      ? const ['38', '39', '40', '41', '42', '43']
      : const ['S', 'M', 'L', 'XL'];

  String get selectedColor => _selectedColor;
  String get selectedSize  => _selectedSize;

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
