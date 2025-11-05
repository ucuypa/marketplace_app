import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⬅️ 1. Import Firestore
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../models/product.dart'; // ⬅️ 2. Import model Product Anda

class NewArrivalsCard extends StatelessWidget {
  const NewArrivalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // ⬅️ 3. Tentukan stream untuk item terbaru
    final Stream<QuerySnapshot> newArrivalStream = FirebaseFirestore.instance
        .collection('items')
        .orderBy('createdAt', descending: true) // Urutkan: terbaru di atas
        .limit(1) // Ambil hanya 1 dokumen
        .snapshots();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          child: Row(
            children: [
              Text(
                'New Arrivals',
                style: inter(
                  context,
                  16,
                  w: FontWeight.w500,
                  color: kTextPrimary,
                ),
              ),
              const Spacer(),
              Text('See all', style: inter(context, 13, color: kPrimary)),
            ],
          ),
        ),
        SizedBox(height: dp(context, 12)),

        // ⬅️ 4. Gunakan StreamBuilder untuk mengambil data
        StreamBuilder<QuerySnapshot>(
          stream: newArrivalStream,
          builder: (context, snapshot) {
            // --- Handle Loading State ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Tampilkan placeholder dengan tinggi yang sama
              return Container(
                height: dp(context, 136),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            // --- Handle Error State ---
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // --- Handle Empty State ---
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No new arrivals found.'));
            }

            // --- Handle Data State ---
            // Ambil satu-satunya dokumen dan ubah menjadi objek Product
            final productDoc = snapshot.data!.docs.first;
            final product = Product.fromFirestore(productDoc);

            // ⬅️ 5. Kembalikan UI card Anda, sekarang dengan data dinamis
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
              child: Container(
                height: dp(context, 136),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(dp(context, 16)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: dp(context, 20),
                      top: dp(context, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.badge ?? 'NEW ARRIVAL', // ⬅️ Ganti
                            style: inter(
                              context,
                              12,
                              w: FontWeight.w500,
                              color: kPrimary,
                            ).copyWith(letterSpacing: 0.96),
                          ),
                          SizedBox(height: dp(context, 2)),
                          Text(
                            product.title, // ⬅️ Ganti
                            style: inter(
                              context,
                              20,
                              w: FontWeight.w500,
                              color: kTextPrimary,
                            ),
                          ),
                          SizedBox(height: dp(context, 8)),
                          Text(
                            product.priceText, // ⬅️ Ganti
                            style: inter(
                              context,
                              16,
                              w: FontWeight.w500,
                              color: kTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: dp(context, 12),
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Transform.rotate(
                          angle: -0.25,
                          // ⬅️ 6. Ganti Image.asset menjadi Image.network
                          child: Image.network(
                            product.imageAsset, // ⬅️ Ganti (ini adalah URL)
                            width: dp(context, 170),
                            fit: BoxFit.contain,
                            // Tambahkan ini untuk UX yang lebih baik
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_not_supported,
                              size: dp(context, 48),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
