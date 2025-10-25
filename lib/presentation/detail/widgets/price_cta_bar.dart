import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';

class PriceCtaBar extends StatelessWidget {
  final String priceText;
  final VoidCallback onAddToCart;
  const PriceCtaBar({super.key, required this.priceText, required this.onAddToCart});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: inter(context, 12, w: FontWeight.w500, color: kTextMuted)),
              SizedBox(height: dp(context, 4)),
              Text(priceText, style: inter(context, 18, w: FontWeight.w700, color: kTextPrimary)),
            ],
          ),
          const Spacer(),
          _cta(context, 'Add To Cart', onAddToCart),
        ],
      );

  Widget _cta(BuildContext ctx, String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: dp(ctx, 48),
          padding: EdgeInsets.symmetric(horizontal: dp(ctx, 20)),
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(dp(ctx, 16)),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withOpacity(.25),
                blurRadius: dp(ctx, 16),
                offset: Offset(0, dp(ctx, 8)),
              ),
            ],
          ),
          child: Center(
            child: Text(label, style: inter(ctx, 15, w: FontWeight.w600, color: Colors.white)),
          ),
        ),
      );
}
