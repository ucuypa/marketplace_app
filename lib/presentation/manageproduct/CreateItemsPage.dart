import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import '../home/models/product.dart';

class CreateItemPage extends StatefulWidget {
  final Product? productToEdit;
  // We pass the raw map for editing because Product model might not have it yet
  final Map<String, dynamic>? currentInventory;
  final String? currentCategory;

  const CreateItemPage({
    super.key,
    this.productToEdit,
    this.currentInventory,
    this.currentCategory,
  });

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  // ⭐️ NEW: Map to store controllers for each size (e.g. "40" -> Controller(text: "5"))
  final Map<String, TextEditingController> _stockControllers = {};

  String? _selectedCategory;
  // We don't need a separate _selectedSizes list anymore,
  // we just check the keys of _stockControllers.

  final List<String> _categories = [
    'Shoes',
    'Sandals',
    'Shirt',
    'T-Shirt',
    'Jacket',
    'Hat',
  ];
  final List<String> _clothingSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _shoeSizes = List.generate(13, (i) => (36 + i).toString());

  XFile? _pickedImage;
  Uint8List? _webImageBytes;
  String? _existingImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    final p = widget.productToEdit!;
    _nameController.text = p.title;
    _descriptionController.text = p.description;
    _priceController.text = p.price.toString();
    _selectedCategory = widget.currentCategory;
    _existingImageUrl = p.imageAsset;

    // ⭐️ PRE-FILL STOCK INPUTS
    if (widget.currentInventory != null) {
      widget.currentInventory!.forEach((size, qty) {
        _stockControllers[size] = TextEditingController(text: qty.toString());
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var c in _stockControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List? tempWebBytes;
    try {
      if (kIsWeb) tempWebBytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        if (kIsWeb) _webImageBytes = tempWebBytes;
      });
    } catch (e) {
      _showErrorSnackbar("Failed to read image");
    }
  }

  // ⭐️ Logic to toggle size selection
  void _toggleSize(String size) {
    setState(() {
      if (_stockControllers.containsKey(size)) {
        // Deselect: Remove controller
        _stockControllers.remove(size);
      } else {
        // Select: Add new controller with default '0' or empty
        _stockControllers[size] = TextEditingController(text: '');
      }
    });
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null && _existingImageUrl == null) {
      _showErrorSnackbar('Please pick a preview image');
      return;
    }
    if (_selectedCategory == null) {
      _showErrorSnackbar('Please select a category');
      return;
    }
    if (_stockControllers.isEmpty) {
      _showErrorSnackbar('Please select at least one size');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final isEditing = widget.productToEdit != null;
      final docRef = isEditing
          ? FirebaseFirestore.instance
                .collection('items')
                .doc(widget.productToEdit!.id)
          : FirebaseFirestore.instance.collection('items').doc();

      String downloadURL = _existingImageUrl ?? '';

      if (_pickedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('item_previews')
            .child('${docRef.id}.jpg');
        final metadata = SettableMetadata(contentType: 'image/jpeg');

        if (kIsWeb) {
          await storageRef.putData(_webImageBytes!, metadata);
        } else {
          await storageRef.putFile(File(_pickedImage!.path), metadata);
        }
        downloadURL = await storageRef.getDownloadURL();
      }

      // ⭐️ CONVERT CONTROLLERS TO MAP & CALCULATE TOTAL STOCK
      Map<String, int> inventoryMap = {};
      int totalStock = 0;
      List<String> sizeList = [];

      _stockControllers.forEach((size, controller) {
        int qty = int.tryParse(controller.text) ?? 0;
        if (qty > 0) {
          inventoryMap[size] = qty;
          totalStock += qty;
          sizeList.add(size);
        }
      });

      // Save Data
      final data = {
        'itemID': docRef.id,
        'sellerID': user.uid,
        'category': _selectedCategory,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'previewImageUrl': downloadURL,
        'itemType': 'physical', // Always physical if it has stock/sizes
        // ⭐️ NEW DATA STRUCTURE
        'stock': totalStock, // Total count for quick display
        'sizes': sizeList, // List of available sizes ["40", "41"]
        'inventory': inventoryMap, // Detail: {"40": 5, "41": 2}

        if (!isEditing) 'createdAt': FieldValue.serverTimestamp(),
      };

      if (isEditing) {
        await docRef.update(data);
      } else {
        await docRef.set(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved!')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Failed: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  // --- WIDGET: CHIPS TO SELECT SIZES ---
  Widget _buildSizeSelector() {
    if (_selectedCategory == null) return const SizedBox.shrink();
    List<String> options = ['Shoes', 'Sandals'].contains(_selectedCategory)
        ? _shoeSizes
        : _clothingSizes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Available Sizes:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((size) {
            final isSelected = _stockControllers.containsKey(size);
            return FilterChip(
              label: Text(size),
              selected: isSelected,
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              onSelected: (_) => _toggleSize(size),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- WIDGET: INPUTS FOR SELECTED SIZES ---
  Widget _buildStockInputs() {
    if (_stockControllers.isEmpty) return const SizedBox.shrink();

    // Sort keys to keep them in order (e.g. 40, 41, 42 or S, M, L)
    // This logic is a bit manual but keeps UI clean
    var sortedKeys = _stockControllers.keys.toList();
    // Basic sort (alphabetic/numeric)
    sortedKeys.sort((a, b) => a.compareTo(b));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Input Stock per Size:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...sortedKeys.map((size) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    size,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stockControllers[size],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity for Size $size',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (int.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Create New Item'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _pickedImage != null
                          ? (kIsWeb
                                ? Image.memory(
                                    _webImageBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                  ))
                          : (_existingImageUrl != null)
                          ? Image.network(_existingImageUrl!, fit: BoxFit.cover)
                          : const Center(child: Text('Tap to pick image')),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        double.tryParse(v!) == null ? 'Invalid' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _stockControllers
                            .clear(); // Reset sizes on category change
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // ⭐️ 1. Select Sizes (Chips)
                  _buildSizeSelector(),
                  const SizedBox(height: 16),

                  // ⭐️ 2. Input Stock for selected sizes
                  _buildStockInputs(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Save Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16).copyWith(bottom: 32),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _saveItem,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(isEditing ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
