// lib/presentation/seller/widgets/seller_header_card.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../models/seller_dashboard_model.dart';

class SellerHeaderCard extends StatelessWidget {
  final SellerDashboardData data;
  const SellerHeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ✅ TAMBAHAN: logic hint kalau nama toko kosong
    final bool isNameEmpty = data.storeName.isEmpty;
    final String displayName =
        isNameEmpty ? 'Set your store name' : data.storeName;

    return Container(
      padding: EdgeInsets.all(dp(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: dp(context, 28),
            backgroundColor: const Color(0xFFF5F5F5),
            backgroundImage: (data.storeAvatarUrl != null &&
                    data.storeAvatarUrl!.isNotEmpty)
                ? NetworkImage(data.storeAvatarUrl!)
                : null,
            child: (data.storeAvatarUrl == null ||
                    data.storeAvatarUrl!.isEmpty)
                ? const Icon(Icons.store, color: Colors.black54)
                : null,
          ),
          SizedBox(width: dp(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ UBAH bagian ini: pakai displayName + warna beda kalau kosong
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isNameEmpty ? Colors.black45 : Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFFFC107),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    const Text('•'),
                    const SizedBox(width: 8),
                    Text(
                      '${data.salesCount} sales',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
