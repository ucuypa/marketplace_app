import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import 'product_card.dart';

class PopularRow extends StatelessWidget {
  const PopularRow({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    return Column(
      children: [
        _sectionHeader(context, 'Popular Product'),
        SizedBox(height: dp(context, 12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          child: Row(
            children: [
              ProductCard(
                badge: 'BEST SELLER',
                title: 'Stussy Angel',
                price: '\$40.99',
                image: 'assets/image/stussy.png',
                onAdd: () {},
                imageHeight: dp(context, 92),
              ),
              SizedBox(width: dp(context, 16)),
              ProductCard(
                badge: 'BEST SELLER',
                title: 'Nike Jordan',
                price: '\$59.99',
                image: 'assets/image/shoes.png',
                onAdd: () {},
                imageHeight: dp(context, 92),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _sectionHeader(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
    child: Row(
      children: [
        Text(title,
            style: inter(context, 16, w: FontWeight.w500, color: kTextPrimary)),
        const Spacer(),
        Text('See all',
            style: inter(context, 13, w: FontWeight.w400, color: kPrimary)),
      ],
    ),
  );
}
