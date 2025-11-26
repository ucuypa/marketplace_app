import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/presentation/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import 'product_card.dart';
import '../../detail/product_detail_page.dart';
import '../models/product.dart';

class PopularRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    final Stream<QuerySnapshot> itemsStream = FirebaseFirestore.instance
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Column(
      children: [
        _sectionHeader(context, 'All Products'),
        SizedBox(height: dp(context, 12)),
        StreamBuilder<QuerySnapshot>(
          stream: itemsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No products found in the database.'),
              );
            }

            final docs = snapshot.data!.docs;

            // --------- LOGIC SEARCH + CATEGORY DI SINI ---------
            final home = context.watch<HomeController>();
            final q = home.searchQuery.trim().toLowerCase();
            final selectedCat = home.selectedCategory; // <- dari controller

            final filteredDocs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final title = (data['name'] ?? data['title'] ?? '')
                  .toString()
                  .toLowerCase();

              final cat = (data['category'] ?? '').toString();

              // match query
              final matchQ = q.isEmpty ? true : title.contains(q);

              // match kategori (null / '' = semua kategori)
              final matchCat = (selectedCat == null || selectedCat.isEmpty)
                  ? true
                  : cat == selectedCat;

              return matchQ && matchCat;
            }).toList();
            // -------------------------------------------

            if (filteredDocs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No products match your search.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
              itemCount: filteredDocs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: dp(context, 16),
                mainAxisSpacing: dp(context, 16),
                childAspectRatio: (160 / 210),
              ),
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final p = Product.fromFirestore(doc);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: p),
                      ),
                    );
                  },
                  child: ProductCard(
                    onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: p),
                        ),
                      );
                    },
                    imageHeight: 130 * s,
                    product: p,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

Widget _sectionHeader(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
    child: Row(
      children: [
        Text(
          title,
          style: inter(context, 16, w: FontWeight.w500, color: kTextPrimary),
        ),
        const Spacer(),
      ],
    ),
  );
}
