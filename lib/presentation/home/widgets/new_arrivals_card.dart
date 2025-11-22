import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../models/product.dart';

class NewArrivalsCard extends StatelessWidget {
  const NewArrivalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> newArrivalStream = FirebaseFirestore.instance
        .collection('items')
        .orderBy('createdAt', descending: true)
        .limit(1)
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
            ],
          ),
        ),
        SizedBox(height: dp(context, 12)),
        StreamBuilder<QuerySnapshot>(
          stream: newArrivalStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: dp(context, 136),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No new arrivals found.'));
            }
            final productDoc = snapshot.data!.docs.first;
            final product = Product.fromFirestore(productDoc);

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
                            product.badge ?? 'NEW ARRIVAL',
                            style: inter(
                              context,
                              12,
                              w: FontWeight.w500,
                              color: kPrimary,
                            ).copyWith(letterSpacing: 0.96),
                          ),
                          SizedBox(height: dp(context, 2)),
                          Text(
                            product.title,
                            style: inter(
                              context,
                              20,
                              w: FontWeight.w500,
                              color: kTextPrimary,
                            ),
                          ),
                          SizedBox(height: dp(context, 8)),
                          Text(
                            product.priceText,
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
                          angle: 0,
                          // Cek apakah URL-nya kosong
                          child: (product.imageAsset.isEmpty)
                              ? Icon(
                                  Icons.image_not_supported,
                                  size: dp(context, 48),
                                )
                              : Image.network(
                                  product.imageAsset,
                                  width: dp(context, 170),
                                  fit: BoxFit.cover,
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
