import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _itemType = 'digital'; // Default type
  List<String> _tags = []; // For tags like 'popular', 'new'
  final _tagsController = TextEditingController();

  // For image upload
  XFile? _pickedImage;
  Uint8List? _webImageBytes;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // User canceled

    Uint8List? tempWebBytes; // Temporary variable

    try {
      if (kIsWeb) {
        // 1. Get the image bytes *first*
        tempWebBytes = await image.readAsBytes();
      }

      // 2. Set all state variables *after* async work is done
      setState(() {
        _pickedImage = image;
        if (kIsWeb) {
          _webImageBytes = tempWebBytes;
        }
      });
    } catch (e) {
      // Handle potential errors during readAsBytes()
      _showErrorSnackbar("Failed to read image: ${e.toString()}");
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return; // Form is not valid
    if (_pickedImage == null) {
      // Show error if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a preview image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Get current user ID
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // 2. Create a new document reference to get a unique ID
      final newItemRef = FirebaseFirestore.instance.collection('items').doc();
      final newItemId = newItemRef.id;

      // 3. Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('item_previews')
          .child('$newItemId.jpg');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      if (kIsWeb) {
        await storageRef.putData(_webImageBytes!, metadata);
      } else {
        await storageRef.putFile(File(_pickedImage!.path), metadata);
      }

      final downloadURL = await storageRef.getDownloadURL();

      // 4. Save item data to Firestore
      await newItemRef.set({
        'sellerID': user.uid,
        'itemType': _itemType,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'previewImageUrl': downloadURL,
        'itemFileUrl': '',
        'tags': _tags,
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully!')),
        );
        Navigator.pop(context); // Go back to the manage page
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create item: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Item'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), // "Cancel" action
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
                  // --- Image Picker ---
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _pickedImage == null
                          ? const Center(
                              child: Text('Tap to pick preview image'),
                            )
                          : (kIsWeb
                                ? Image.memory(
                                    _webImageBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                  )),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Name ---
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Description ---
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),

                  // --- Price ---
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => (double.tryParse(value ?? '') == null)
                        ? 'Enter a valid price'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Item Type ---
                  DropdownButtonFormField<String>(
                    value: _itemType,
                    items: const [
                      DropdownMenuItem(
                        value: 'digital',
                        child: Text('Digital Item'),
                      ),
                      DropdownMenuItem(
                        value: 'physical',
                        child: Text('Physical Item'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _itemType = value);
                    },
                    decoration: const InputDecoration(labelText: 'Item Type'),
                  ),

                  // --- Tags ---
                  // (A simple tags implementation)
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma-separated)',
                      hintText: 'e.g., popular, new, minimal',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _tags = value
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();
                      });
                    },
                  ),

                  // Space for the bottom buttons
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // --- "Cancel" and "Save" Buttons ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 32.0),
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save'),
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

  void _showErrorSnackbar(String s) {
    void _showErrorSnackbar(String message) {
      // Cek apakah widget masih ada di tree sebelum menampilkan snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red, // Beri warna merah untuk error
          ),
        );
      }
    }
  }
}
