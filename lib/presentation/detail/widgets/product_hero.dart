import 'package:flutter/material.dart';
import '../../shared/scale.dart';


class ProductHero extends StatelessWidget {
  final String imageAsset;
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
            child: Image.asset(
              imageAsset,
              height: dp(context, 180),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.image, size: dp(context, 40)),
            ),
          ),
        ),
      );
}
