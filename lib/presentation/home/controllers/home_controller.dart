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
    _init(); // Call _init to fetch data
  }

  // === STATE ===
  List<Product> _all = [];
  bool _isLoading = true;

  // ⭐️ Changed from Enum to String? (null means 'All Categories')
  String? _selectedCategory;

  String _query = '';

  // User Data State
  String? _userRole;
  String? _userName;

  // === GETTERS ===
  bool get isLoading => _isLoading;
  String get searchQuery => _query;

  // ⭐️ Return String?
  String? get selectedCategory => _selectedCategory;

  String? get userRole => _userRole;
  String? get userName => _userName;

  List<Product> get popular => _all.where((p) => p.isPopular).toList();

  List<Product> get filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((p) {
      // ⭐️ Updated Category Logic
      // If _selectedCategory is null, show everything.
      // Otherwise, match the product's category String.
      final matchCat = (_selectedCategory == null)
          ? true
          : p.category == _selectedCategory;

      final matchQ = q.isEmpty ? true : p.title.toLowerCase().contains(q);

      return matchCat && matchQ;
    }).toList();
  }

  List<Product> get filteredPopular =>
      filtered.where((p) => p.isPopular).toList();

  // === METHODS ===

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // 1. Fetch Products
    _all = await _repo.fetchAll();

    // 2. Fetch User Role
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
    notifyListeners();
  }

  Future<void> becomeSeller(BuildContext context) async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Not logged in");

      // Update data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'role': 'seller'},
      );

      // Update local state
      _userRole = 'seller';
      notifyListeners();

      // Show notification
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Congratulations! You are now a Seller.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error becoming seller: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ⭐️ Updated to accept String? (or null for 'All')
  void setCategory(String? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_query == query) return;
    _query = query;
    notifyListeners();
  }
}
