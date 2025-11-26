import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../models/product.dart'; // ⬅️ Pastikan import ini ada

class ProductCard extends StatelessWidget {
  // ⬅️ Kita ubah parameter individu menjadi satu objek Product
  final Product product;
  final VoidCallback onAdd;
  final double imageHeight;

  const ProductCard({
    super.key,
    required this.product, // ⬅️ Parameter baru
    required this.onAdd,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: dp(context, 205),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dp(context, 16)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: dp(context, 12),
            top: dp(context, 8),
            right: dp(context, 12),
            child: SizedBox(
              height: imageHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Transform.rotate(
                  angle: -0.25,
                  child: (product.imageAsset.isEmpty)
                      ? Icon(Icons.image_not_supported, size: dp(context, 36))
                      : Image.network(
                          product.imageAsset,
                          height: imageHeight,
                          fit: BoxFit.cover, // Agar gambar pas di kotak
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported,
                            size: dp(context, 36),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Positioned(
            left: dp(context, 12),
            right: dp(context, 12),
            bottom: dp(context, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.badge, // ⬅️ Ambil dari product
                        style: inter(
                          context,
                          11,
                          w: FontWeight.w500,
                          color: kPrimary,
                        ),
                      ),
                      SizedBox(height: dp(context, 1)),
                      Text(
                        product.title, // ⬅️ Ambil dari product
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: inter(
                          context,
                          14,
                          w: FontWeight.w600,
                          color: kTextPrimary,
                        ),
                      ),
                      SizedBox(height: dp(context, 4)),
                      Text(
                        product.priceText, // ⬅️ Ambil dari product
                        style: inter(
                          context,
                          13,
                          w: FontWeight.w500,
                          color: kTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: dp(context, 6)),
                _AddBtn(onTap: onAdd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = dp(context, 36);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/icon/AddProduct3.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
