import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../controllers/home_controller.dart';
import 'product_card.dart';
import '../../detail/product_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
          itemCount: popular.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Tampilkan 2 item per baris
            crossAxisSpacing: dp(context, 16),
            mainAxisSpacing: dp(context, 16),
            childAspectRatio: (160 / 210),
          ),

          itemBuilder: (context, index) {
            final p = popular[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: p),
                  ),
                );
              },
              child: ProductCard(
                badge: p.badge,
                title: p.title,
                price: p.priceText,
                image: p.imageAsset,
                onAdd: () {}, // tetap: tombol plus jika mau
                imageHeight: 130 * s,
              ),
            );
          },
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
        Text(
          title,
          style: inter(context, 16, w: FontWeight.w500, color: kTextPrimary),
        ),
        const Spacer(),
        Text(
          'See all',
          style: inter(context, 13, w: FontWeight.w400, color: kPrimary),
        ),
      ],
    ),
  );
}
