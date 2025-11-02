import 'package:flutter/material.dart';
import '../../../presentation/shared/scale.dart';
import '../../../presentation/shared/ui_constants.dart';

class CartAppBar extends StatelessWidget {
  final VoidCallback onBack;
  const CartAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dp(context, 16),
          vertical: dp(context, 8),
        ),
        child: Row(
          children: [
            _iconBtn(context, Icons.arrow_back_ios_new_rounded, onBack),
            Expanded(
              child: Center(
                child: Text('My Cart',
                    style: inter(context, 16,
                        w: FontWeight.w600, color: kTextPrimary)),
              ),
            ),
            SizedBox(width: dp(context, 40)), // spacer biar simetris
          ],
        ),
      );

  Widget _iconBtn(BuildContext ctx, IconData ic, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: dp(ctx, 40),
          height: dp(ctx, 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(dp(ctx, 12)),
          ),
          child: Icon(ic, size: dp(ctx, 18), color: kTextPrimary),
        ),
      );
}
