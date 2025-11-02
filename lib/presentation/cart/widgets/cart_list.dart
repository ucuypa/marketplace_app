import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/shared/scale.dart';
import '../../../presentation/shared/ui_constants.dart';
import '../application/cart_controller.dart';
import 'cart_item_row.dart';

class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (_, cart, __) {
        if (cart.items.isEmpty) {
          return Center(
            child: Text('Your cart is empty',
                style: inter(context, 14, color: kTextMuted)),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(dp(context, 16)),
          itemCount: cart.items.length,
          separatorBuilder: (_, __) => SizedBox(height: dp(context, 12)),
          itemBuilder: (_, i) => CartItemRow(item: cart.items[i]),
        );
      },
    );
  }
}
