import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import 'product_card.dart';
import '../../detail/product_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class PopularRow extends StatelessWidget {
  const PopularRow({super.key});

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

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
              itemCount: docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: dp(context, 16),
                mainAxisSpacing: dp(context, 16),
                childAspectRatio: (160 / 210),
              ),
              itemBuilder: (context, index) {
                final doc = docs[index];
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
                    badge: p.badge,
                    title: p.title,
                    price: "\$${p.price.toStringAsFixed(2)}",
                    image: p.imageAsset,
                    onAdd: () {},
                    imageHeight: 130 * s,
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
