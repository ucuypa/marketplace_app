import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class PriceCtaBar extends StatelessWidget {
  final String priceText;
  final VoidCallback onAddToCart;

  const PriceCtaBar({
    super.key,
    required this.priceText,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dp(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dp(context, 24)),
          topRight: Radius.circular(dp(context, 24)),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Price Section
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: inter(
                    context,
                    12,
                    w: FontWeight.w400,
                    color: kTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  priceText,
                  style: inter(
                    context,
                    20,
                    w: FontWeight.w700,
                    color: kTextPrimary,
                  ),
                ),
              ],
            ),

            SizedBox(width: dp(context, 24)),

            // Add to Cart Button
            Expanded(
              child: SizedBox(
                height: dp(context, 52),
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(dp(context, 16)),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: inter(context, 16, w: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
