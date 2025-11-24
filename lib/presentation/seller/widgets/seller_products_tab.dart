// lib/presentation/seller/widgets/seller_products_tab.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../models/seller_dashboard_model.dart';
import 'seller_product_item_card.dart';

class SellerProductsTab extends StatelessWidget {
  final SellerDashboardData data;
  const SellerProductsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: dp(context, 12)),

        // If no products, show placeholder text; otherwise show list
        if (data.products.isEmpty) ...[
          const Text(
            'No products yet.',
            style: TextStyle(color: Colors.black54),
          ),
        ] else ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.products
                .map(
                  (p) => Padding(
                    padding: EdgeInsets.only(bottom: dp(context, 12)),
                    child: SellerProductItemCard(product: p),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
