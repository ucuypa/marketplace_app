import 'package:flutter/material.dart';
import '../../shared/scale.dart';

class ProductHero extends StatelessWidget {
  final String imageAsset; // Ini sekarang adalah URL, bukan path aset
  const ProductHero({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
    child: Container(
      height: dp(context, 240),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dp(context, 24)),
      ),
      child: Center(
        // ⬅️ Cek apakah URL-nya kosong
        child: (imageAsset.isEmpty)
            ? Icon(
                Icons.image_not_supported,
                size: dp(context, 40),
                color: Colors.grey,
              )
            // ⬅️ Ganti Image.asset menjadi Image.network
            : Image.network(
                imageAsset, // Ini adalah URL dari Firebase
                height: dp(context, 180),
                fit: BoxFit.contain,
                // ⬅️ Tambahkan loading builder untuk UX yang lebih baik
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.image_not_supported, size: dp(context, 40)),
              ),
      ),
    ),
  );
}
