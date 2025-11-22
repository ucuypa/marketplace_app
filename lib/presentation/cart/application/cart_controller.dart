import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/models/product.dart';
import '../../cart/models/cart_item.dart';
import '../../address_user/address_model.dart';
import '../models/courier_model.dart';

class CartController extends ChangeNotifier {
  // Internal local state, synced from Firestore
  Map<String, CartItem> _items = {};

  // Checkout State
  AddressModel? _selectedAddress;
  CourierModel? _selectedCourier;
  bool _isLoading = false;

  // Subscription to listen to DB changes
  // ignore: unused_field
  var _cartSubscription;

  CartController() {
    _initCartStream();
  }

  // 1. LISTENER: Sync with Firestore automatically
  void _initCartStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _cartSubscription = FirebaseFirestore.instance
        .collection('cart_item')
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
          _items = {};
          for (var doc in snapshot.docs) {
            final data = doc.data();

            final product = Product(
              id: data['itemID'],
              title: data['title'],
              price: (data['price'] as num).toDouble(),
              imageAsset: data['image'] ?? '',
              description: '',
            );

            final cartItem = CartItem(
              id: doc.id,
              product: product,
              // ⬇️ CHANGE THIS LINE (from 'quantity' to 'qty')
              qty: data['quantity'] ?? 1,
              size: data['size'] ?? '',
            );

            _items[doc.id] = cartItem;
          }
          notifyListeners();
        });
  }

  // Getters
  List<CartItem> get items => _items.values.toList();
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.qty);
  bool get isLoading => _isLoading;
  AddressModel? get selectedAddress => _selectedAddress;
  CourierModel? get selectedCourier => _selectedCourier;

  double get subtotal =>
      _items.values.fold(0.0, (sum, it) => sum + it.lineTotal);
  double get shippingCost => _selectedCourier?.price ?? 0.0;
  double get total => subtotal + shippingCost;

  // Setters for Checkout
  void setAddress(AddressModel? address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void setCourier(CourierModel? courier) {
    _selectedCourier = courier;
    notifyListeners();
  }

  // 2. ADD: Write to Firestore
  Future<void> add(Product p, {required String? size, int qty = 1}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final itemSize = size ?? '';

    // Check if item already exists in cart with same ID and Size
    // We do this locally to find the doc ID, then update Firestore
    try {
      final existingEntry = _items.values.firstWhere(
        (i) => i.product.id == p.id && i.size == itemSize,
        orElse: () => CartItem(product: p, qty: -1, size: ''), // Dummy
      );

      if (existingEntry.qty != -1) {
        // UPDATE existing doc
        await FirebaseFirestore.instance
            .collection('cart_item')
            .doc(existingEntry.id) // Use the Firestore Doc ID
            .update({'quantity': existingEntry.qty + qty});
      } else {
        // CREATE new doc
        // We replicate product details here for easy reading (NoSQL style)
        await FirebaseFirestore.instance.collection('cart_item').add({
          'userID': user.uid,
          'itemID': p.id,
          'title': p.title,
          'price': p.price,
          'image': p.imageAsset,
          'size': itemSize,
          'quantity': qty,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  // 3. INC/DEC: Update Firestore
  Future<void> inc(CartItem it) async {
    if (it.id == null) return;
    await FirebaseFirestore.instance.collection('cart_item').doc(it.id).update({
      'quantity': it.qty + 1,
    });
  }

  Future<void> dec(CartItem it) async {
    if (it.id == null) return;
    if (it.qty > 1) {
      await FirebaseFirestore.instance
          .collection('cart_item')
          .doc(it.id)
          .update({'quantity': it.qty - 1});
    }
  }

  // 4. REMOVE: Delete from Firestore
  Future<void> remove(CartItem it) async {
    if (it.id == null) return;
    await FirebaseFirestore.instance
        .collection('cart_item')
        .doc(it.id)
        .delete();
  }

  // 5. CHECKOUT (Same as before, but simplified cart clearing)
  Future<void> checkout(String paymentMethod) async {
    if (_items.isEmpty) throw Exception("Cart is empty");
    if (_selectedAddress == null) throw Exception("Please select an address");
    if (_selectedCourier == null)
      throw Exception("Please select a shipping method");

    _isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        double calculatedItemTotal = 0;
        final orderRef = firestore.collection('orders').doc();

        // Process items (Stock check logic remains the same as previous)
        for (var cartItem in _items.values) {
          final itemRef = firestore
              .collection('items')
              .doc(cartItem.product.id);
          final itemSnapshot = await transaction.get(itemRef);

          if (!itemSnapshot.exists) throw Exception("Product missing");

          // ... (Stock checking logic omitted for brevity, keep your previous logic here) ...

          // Create Order Item
          final orderItemRef = firestore.collection('order_items').doc();
          transaction.set(orderItemRef, {
            'orderID': orderRef.id,
            'itemID': cartItem.product.id,
            'productName': cartItem.product.title,
            'productImage': cartItem.product.imageAsset,
            'quantity': cartItem.qty,
            'size': cartItem.size,
            'priceAtPurchase': cartItem.product.price,
          });

          calculatedItemTotal += (cartItem.product.price * cartItem.qty);
        }

        // Create Order
        final firstItem = _items.values.first.product;
        transaction.set(orderRef, {
          'orderID': orderRef.id,
          'buyerID': user!.uid,
          'addressSnapshot': _selectedAddress!.toMap(),
          'totalAmountPaid': calculatedItemTotal + _selectedCourier!.price,
          'previewProductName': firstItem.title,
          'previewProductImage': firstItem.imageAsset,
          'orderDate': FieldValue.serverTimestamp(),
          'status': 'paid',
        });

        // Create Shipment
        final shipmentRef = firestore.collection('shipment').doc();
        transaction.set(shipmentRef, {
          'orderID': orderRef.id,
          'status': 'processing',
          'shippingCarrier': _selectedCourier!.name,
        });
      });

      // CLEAR CART (Delete all documents in subcollection)
      // Note: In a real transaction, you'd delete these inside the transaction,
      // but deleting a whole collection is hard in a transaction.
      // We do it simply here:
      final batch = firestore.batch();
      for (var key in _items.keys) {
        batch.delete(firestore.collection('cart_item').doc(key));
      }
      await batch.commit();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
