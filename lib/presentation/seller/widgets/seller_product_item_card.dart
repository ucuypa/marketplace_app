// lib/presentation/seller/widgets/seller_product_item_card.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../seller_dashboard_model.dart';

class SellerProductItemCard extends StatelessWidget {
  final SellerProduct product;
  const SellerProductItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dp(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: dp(context, 60),
            height: dp(context, 60),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: product.imageUrl.isEmpty
                ? const Icon(Icons.image, color: Colors.black45)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(width: dp(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
