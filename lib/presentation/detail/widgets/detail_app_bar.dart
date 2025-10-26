import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../home/models/product.dart';

class DetailAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  final Product product;

  const DetailAppBar({
    super.key,
    required this.onBack,
    required this.title,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesController>();
    // Sesuaikan dengan signature controllermu:
    final isFav = fav.isFavorite(product); // atau fav.isFavorite(product);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dp(context, 16),
        vertical: dp(context, 8),
      ),
      child: Row(
        children: [
          _iconBtn(context, icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: inter(context, 14, w: FontWeight.w600, color: kTextPrimary),
              ),
            ),
          ),

          // HEART: toggle favorite TANPA navigasi
          GestureDetector(
            onTap: () {
              context.read<FavoritesController>().toggle(product);

              // (Opsional) Feedback kecil
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav ? 'Removed from favourites' : 'Added to favourites',
                    style: inter(context, 13, color: Colors.white),
                  ),
                  duration: const Duration(milliseconds: 1200),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: isFav ? kTextMuted : kPrimary,
                  margin: EdgeInsets.symmetric(
                    horizontal: dp(context, 16),
                    vertical: dp(context, 8),
                  ),
                ),
              );
            },
            child: Container(
              width: dp(context, 40),
              height: dp(context, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(context, 12)),
              ),
              child: Center(
                child: isFav
                    ? Image.asset(
                        'assets/icon/HeartFill.png',
                        width: dp(context, 18),
                        height: dp(context, 18),
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.favorite, color: Colors.red, size: dp(context, 18)),
                      )
                    : Image.asset(
                        'assets/icon/Heart.png',
                        width: dp(context, 18),
                        height: dp(context, 18),
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.favorite_border,
                          size: dp(context, 18),
                          color: kTextPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
