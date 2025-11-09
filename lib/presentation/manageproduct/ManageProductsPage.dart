import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../home/models/product.dart'; // ⬅️ Import your Product model
import 'CreateItemsPage.dart'; // ⬅️ Import the create page

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  // Get the current seller's ID
  final String currentSellerId = auth.FirebaseAuth.instance.currentUser!.uid;

  // Stream for the seller's items
  late final Stream<QuerySnapshot> _itemsStream;

  @override
  void initState() {
    super.initState();
    // Query 'items' collection where 'sellerID' matches our ID
    _itemsStream = FirebaseFirestore.instance
        .collection('items')
        .where('sellerID', isEqualTo: currentSellerId)
        .snapshots();
  }

  // Function to delete an item
  Future<void> _deleteItem(String docId) async {
    // TODO: Also delete the item's images from Firebase Storage
    try {
      await FirebaseFirestore.instance.collection('items').doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete item: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _itemsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('You have not created any items yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final product = Product.fromFirestore(doc);

              // This is the list tile for each item
              return ListTile(
                leading: Image.network(
                  product.imageAsset, // This is the previewImageUrl
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                title: Text(product.title),
                subtitle: Text(product.priceText),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: Text(
                          'Do you want to delete "${product.title}"?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _deleteItem(product.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateItemPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
