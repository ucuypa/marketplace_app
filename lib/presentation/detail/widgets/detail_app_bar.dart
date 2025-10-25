import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';

class DetailAppBar extends StatelessWidget {
  final VoidCallback onBack;
  const DetailAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dp(context, 16),
          vertical: dp(context, 8),
        ),
        child: Row(
          children: [
            _iconBtn(context, icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
            const Spacer(),
            _iconBtn(context, icon: Icons.lock_outline_rounded),
          ],
        ),
      );

  Widget _iconBtn(BuildContext ctx, {required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dp(ctx, 40),
        height: dp(ctx, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(ctx, 12)),
        ),
        child: Icon(icon, size: dp(ctx, 18), color: kTextPrimary),
      ),
    );
  }
}
