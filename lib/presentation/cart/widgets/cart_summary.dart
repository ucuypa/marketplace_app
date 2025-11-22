import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/shared/scale.dart';
import '../../../presentation/shared/ui_constants.dart';
import '../application/cart_controller.dart';
import '../../checkout/checkout_page.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (_, cart, __) => Container(
        margin: EdgeInsets.all(dp(context, 16)),
        padding: EdgeInsets.all(dp(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(context, 20)),
        ),
        child: Column(
          children: [
            _summaryLine(context, 'Total Cost', cart.total, bold: true),
            SizedBox(height: dp(context, 12)),

            _checkoutBtn(context, cart),
          ],
        ),
      ),
    );
  }

  Widget _summaryLine(
    BuildContext ctx,
    String label,
    double value, {
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dp(ctx, 6)),
      child: Row(
        children: [
          Text(label, style: inter(ctx, 14, color: kTextMuted)),
          const Spacer(),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: inter(
              ctx,
              bold ? 16 : 14,
              w: bold ? FontWeight.w700 : FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutBtn(BuildContext ctx, CartController cart) {
    return GestureDetector(
      onTap: () {
        if (cart.items.isEmpty) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(const SnackBar(content: Text("Your cart is empty!")));
          return;
        }

        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const CheckoutPage()),
        );
      },
      child: Container(
        height: dp(ctx, 52),
        width: double.infinity,
        decoration: BoxDecoration(
          color: cart.items.isEmpty ? Colors.grey : kPrimary,
          borderRadius: BorderRadius.circular(dp(ctx, 24)),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(.25),
              blurRadius: dp(ctx, 18),
              offset: Offset(0, dp(ctx, 8)),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Checkout',
            style: inter(ctx, 15, w: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
