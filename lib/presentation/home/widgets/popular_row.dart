import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // ⬅️ untuk PointerDeviceKind
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
        SizedBox(
          height: dp(context, 210), // ⬅️ tinggi container diperbesar untuk title
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse, // ⬅️ enable mouse drag untuk web
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // ⬅️ scroll horizontal
              physics: const BouncingScrollPhysics(), // ⬅️ smooth scroll dengan bounce effect
              padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
              itemCount: popular.length, // ⬅️ tampilkan semua product
              itemBuilder: (context, index) {
                final p = popular[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < popular.length - 1 ? dp(context, 16) : 0,
                  ),
                  child: SizedBox(
                    width: dp(context, 160), // ⬅️ lebar tetap untuk setiap card
                    child: ProductCard(
                      badge: p.badge,
                      title: p.title,
                      price: p.priceText,
                      image: p.imageAsset,
                      onAdd: () {},
                      imageHeight: 130 * s, // ⬅️ gambar dikecilkan sedikit agar title fit
                    ),
                  ),
                );
              },
            ),
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
