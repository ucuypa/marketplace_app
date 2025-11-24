// lib/presentation/seller/widgets/seller_home_tab.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../models/seller_dashboard_model.dart';
import 'seller_product_item_card.dart';

class SellerHomeTab extends StatelessWidget {
  final SellerDashboardData data;
  const SellerHomeTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (data.products.isEmpty)
          const Text(
            'No products yet. Add your first product!',
            style: TextStyle(color: Colors.black54),
          )
        else
          SellerProductItemCard(product: data.products.first),
        const SizedBox(height: 24),
      ],
    );
  }
}
