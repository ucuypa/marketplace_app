import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/product.dart';
import '../data/product_repository.dart';

class HomeController with ChangeNotifier {
  final ProductRepository _repo;

  // Constructor
  HomeController({ProductRepository? repo})
    : _repo = repo ?? const ProductRepository() {
    _init(); // Panggil _init untuk mengambil data
  }

  // === STATE ===
  List<Product> _all = [];
  bool _isLoading = true;
  Category _selected = Category.all;
  String _query = '';

  // ⬇️ State baru untuk data pengguna
  String? _userRole;
  String? _userName;

  // === GETTERS ===
  bool get isLoading => _isLoading;
  String get searchQuery => _query;
  Category get selectedCategory => _selected;
  String? get userRole => _userRole; // ⬅️ Getter untuk role
  String? get userName => _userName; // ⬅️ Getter untuk nama

  List<Product> get popular => _all.where((p) => p.isPopular).toList();

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

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _all = await _repo.fetchAll();

    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          _userRole = userDoc.data()?['role'];
          _userName = userDoc.data()?['name'];
        }
      }
    } catch (e) {
      print("Error fetching user role: $e");
    }

    _isLoading = false;
    notifyListeners(); // Beri tahu UI untuk menampilkan data
  }

  Future<void> becomeSeller(BuildContext context) async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Not logged in");

      // Update data di Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'role': 'seller'},
      );

      // Perbarui state lokal
      _userRole = 'seller';
      notifyListeners();

      // Tampilkan notifikasi
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selamat! Anda sekarang adalah Seller.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error becoming seller: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui role: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void setCategory(Category category) {
    _selected = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _query = query;
    notifyListeners();
  }
}
