import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../controllers/home_controller.dart';
import 'product_card.dart';

class PopularRow extends StatelessWidget {
  const PopularRow({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    final popular = context.watch<HomeController>().filteredPopular;

    return Column(
      children: [
        _sectionHeader(context, 'Popular Product'),
        SizedBox(height: dp(context, 12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          child: Row(
            children: [
              for (final p in popular.take(2)) ...[
                ProductCard(
                  badge: p.badge,
                  title: p.title,
                  price: p.priceText,
                  image: p.imageAsset,
                  onAdd: () {},
                  imageHeight: 120 * s, // ⬅️ diperbesar dari 92 ke 120
                ),
                SizedBox(width: dp(context, 16)),
              ],
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
