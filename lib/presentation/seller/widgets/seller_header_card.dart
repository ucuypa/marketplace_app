// lib/presentation/seller/widgets/seller_header_card.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../seller_dashboard_model.dart';

class SellerHeaderCard extends StatelessWidget {
  final SellerDashboardData data;
  const SellerHeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  data.storeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
