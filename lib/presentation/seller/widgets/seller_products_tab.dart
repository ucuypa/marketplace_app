// lib/presentation/seller/widgets/seller_products_tab.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';
import '../seller_dashboard_model.dart';
import 'seller_product_item_card.dart';

class SellerProductsTab extends StatelessWidget {
  final SellerDashboardData data;
  const SellerProductsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.products.isEmpty) {
      return const Text(
        'No products yet.',
        style: TextStyle(color: Colors.black54),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.products
          .map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: dp(context, 12)),
              child: SellerProductItemCard(product: p),
            ),
          )
          .toList(),
    );
  }
}
