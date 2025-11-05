import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// import 'package:provider/provider.dart'; // ⬅️ Dihapus
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
// import '../controllers/home_controller.dart'; // ⬅️ Dihapus
import 'product_card.dart';
import '../../detail/product_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ⬅️ 1. PASTIKAN Anda mengimpor model Product Anda
import '../models/product.dart'; // Sesuaikan path ini jika perlu

class PopularRow extends StatelessWidget {
  const PopularRow({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;

    // ⬅️ 2. Tentukan stream yang akan didengarkan
    final Stream<QuerySnapshot> itemsStream = FirebaseFirestore.instance
        .collection('items')
        .orderBy('createdAt', descending: true) // Urutkan berdasarkan terbaru
        .snapshots();

    return Column(
      children: [
        // ⬅️ 3. Saya ganti judulnya menjadi "All Products"
        _sectionHeader(context, 'All Products'),
        SizedBox(height: dp(context, 12)),

        // ⬅️ 4. Gunakan StreamBuilder untuk mengambil data
        StreamBuilder<QuerySnapshot>(
          stream: itemsStream,
          builder: (context, snapshot) {
            // --- Handle Loading State ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // --- Handle Error State ---
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // --- Handle Empty State ---
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No products found in the database.'),
              );
            }

            // --- Handle Data State ---
            // Kita punya data!
            final docs = snapshot.data!.docs;

            // ⬅️ 5. GridView.builder Anda sekarang ada di dalam StreamBuilder
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
              itemCount: docs.length, // ⬅️ Gunakan jumlah data dari database
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: dp(context, 16),
                mainAxisSpacing: dp(context, 16),
                childAspectRatio: (160 / 210),
              ),
              itemBuilder: (context, index) {
                // ⬅️ 6. Ubah dokumen Firestore menjadi objek Product
                final doc = docs[index];
                final p = Product.fromFirestore(doc); // ⬅️ Ini adalah kuncinya

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ⬅️ 7. Kirim 'p' yang sudah di-map ke detail page
                        builder: (_) => ProductDetailPage(product: p),
                      ),
                    );
                  },
                  child: ProductCard(
                    badge: p.badge,
                    title: p.title,
                    price:
                        "\$${p.price.toStringAsFixed(2)}", // ⬅️ Konversi price
                    image: p.imageAsset, // Ini sekarang adalah URL
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

// Widget _sectionHeader tidak berubah
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
        Text(
          'See all',
          style: inter(context, 13, w: FontWeight.w400, color: kPrimary),
        ),
      ],
    ),
  );
}
