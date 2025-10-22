import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class NewArrivalsCard extends StatelessWidget {
  const NewArrivalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          child: Row(
            children: [
              Text('New Arrivals',
                  style: inter(context, 16, w: FontWeight.w500, color: kTextPrimary)),
              const Spacer(),
              Text('See all', style: inter(context, 13, color: kPrimary)),
            ],
          ),
        ),
        SizedBox(height: dp(context, 12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          child: Container(
            height: dp(context, 136),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(dp(context, 16)),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: dp(context, 20),
                  top: dp(context, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BEST CHOICE',
                          style: inter(context, 12,
                                  w: FontWeight.w500, color: kPrimary)
                              .copyWith(letterSpacing: 0.96)),
                      SizedBox(height: dp(context, 2)),
                      Text('Nike Air Jordan',
                          style: inter(context, 20,
                              w: FontWeight.w500, color: kTextPrimary)),
                      SizedBox(height: dp(context, 8)),
                      Text('\$97.69',
                          style: inter(context, 16,
                              w: FontWeight.w500, color: kTextPrimary)),
                    ],
                  ),
                ),
                Positioned(
                  right: dp(context, 12),
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: -0.25,
                      child: Image.asset(
                        'assets/image/shoes.png',
                        width: dp(context, 170),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image_not_supported, size: dp(context, 48)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
