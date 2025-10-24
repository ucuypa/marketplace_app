import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class ProductCard extends StatelessWidget {
  final String badge, title, price, image;
  final VoidCallback onAdd;
  final double imageHeight;
  const ProductCard({
    super.key,
    required this.badge,
    required this.title,
    required this.price,
    required this.image,
    required this.onAdd,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container( // ⬅️ ubah dari Expanded jadi Container biasa
      width: double.infinity,
      height: dp(context, 205), // ⬅️ tinggi card diperbesar agar title muat
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
              height: imageHeight, // ⬅️ gunakan imageHeight parameter
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Transform.rotate(
                  angle: -0.25,
                  child: Image.asset(
                    image,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image_not_supported, size: dp(context, 36)),
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
                      Text(badge,
                          style: inter(context, 11, // ⬅️ dikecilkan dari 12
                              w: FontWeight.w500, color: kPrimary)),
                      SizedBox(height: dp(context, 1)), // ⬅️ dikecilkan dari 2
                      Text(title,
                          maxLines: 2, // ⬅️ 2 baris untuk title yang panjang
                          overflow: TextOverflow.ellipsis,
                          style: inter(context, 14, // ⬅️ dikecilkan dari 16
                              w: FontWeight.w600, color: kTextPrimary)),
                      SizedBox(height: dp(context, 4)), // ⬅️ dikecilkan dari 6
                      Text(price,
                          style: inter(context, 13, // ⬅️ dikecilkan dari 14
                              w: FontWeight.w500, color: kTextPrimary)),
                    ],
                  ),
                ),
                SizedBox(width: dp(context, 6)), // ⬅️ dikecilkan dari 8
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
    final size = dp(context, 36); // 36–40

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/icon/AddProduct3.png',
          fit: BoxFit.contain,        // isi penuh tanpa background tambahan
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

