import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/product_repository.dart'; // ⬅️ 1. Import repository

class HomeController with ChangeNotifier {
  final ProductRepository _repo;

  // Constructor-nya sekarang memanggil _init()
  HomeController({ProductRepository? repo})
    : _repo = repo ?? const ProductRepository() {
    _init(); // ⬅️ 2. Panggil _init() untuk mengambil data
  }

  // === STATE ===

  // Data dari database
  List<Product> _all = [];

  // State untuk UI
  bool _isLoading = true; // ⬅️ 3. Tambahkan loading state
  Category _selected = Category.all;
  String _query = '';

  // === GETTERS ===

  bool get isLoading => _isLoading;
  String get searchQuery => _query;
  Category get selectedCategory => _selected;
  List<Product> get popular => _all.where((p) => p.isPopular).toList();

  // Getter ini sekarang me-return list yang sudah difilter
  List<Product> get filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((p) {
      final matchCat = _selected == Category.all
          ? true
          : p.categories.contains(_selected);
      final matchQ = q.isEmpty ? true : p.title.toLowerCase().contains(q);
      return matchCat && matchQ;
    }).toList();
  }

  List<Product> get filteredPopular =>
      filtered.where((p) => p.isPopular).toList();
  // === METHODS ===

  // ⬅️ 5. Fungsi _init() untuk mengambil data dari repository
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners(); // Beri tahu UI untuk menampilkan loading

    _all = await _repo.fetchAll(); // ⬅️ Ambil data dari Firestore

    _isLoading = false;
    notifyListeners(); // Beri tahu UI untuk menampilkan data
  }

  // Panggil ini saat chip kategori di-tap
  void setCategory(Category category) {
    _selected = category;
    notifyListeners(); // Update UI
  }

  // Panggil ini saat search bar berubah
  void setSearchQuery(String query) {
    _query = query;
    notifyListeners(); // Update UI
  }
}
