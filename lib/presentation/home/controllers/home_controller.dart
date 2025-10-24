import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

class HomeController extends ChangeNotifier {
  HomeController({ProductRepository? repo})
      : _repo = repo ?? const ProductRepository() {
    _all = _repo.fetchAll();
  }

  final ProductRepository _repo;
  late final List<Product> _all;

  // --- state baru ---
  String _query = '';
  Category _selected = Category.all;

  // --- getters publik ---
  List<Product> get all => List.unmodifiable(_all);
  List<Product> get popular => _all.where((p) => p.isPopular).toList();
  String get searchQuery => _query;
  Category get selectedCategory => _selected;

  // hasil akhir (search + kategori)
  List<Product> get filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((p) {
      final matchCat =
          _selected == Category.all ? true : p.category == _selected;
      final matchQ = q.isEmpty ? true : p.title.toLowerCase().contains(q);
      return matchCat && matchQ;
    }).toList();
  }
  // ⬇️ TAMBAHKAN ini
List<Product> get filteredPopular =>
    filtered.where((p) => p.isPopular).toList();

  // --- actions ---
  void setSearchQuery(String v) {
    if (v == _query) return;
    _query = v;
    notifyListeners();
  }

  void setCategory(Category c) {
    if (c == _selected) return;
    _selected = c;
    notifyListeners();
  }
}
