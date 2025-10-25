import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // enable mouse/touch drag on web
import 'package:provider/provider.dart';               // ⬅️ tambah
import '../../shared/scale.dart';
import '../controllers/home_controller.dart';         // ⬅️ tambah
import '../models/product.dart';                      // ⬅️ enum Category

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    final selected = context.watch<HomeController>().selectedCategory; // ⬅️ baca state

    Widget chip(String label, bool filled, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap, // ⬅️ update state
        child: Container(
          height: 32 * s,
          padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 12 * s),
          decoration: BoxDecoration(
            color: filled ? const Color(0xFF222222) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(9999),
            border: filled
                ? null
                : Border.all(width: 1, color: const Color(0xFFF1EEEF)),
          ),
          child: Center(
            child: Text(
              label,
              style: inter(
                context,
                12,
                w: FontWeight.w500,
                color: filled ? Colors.white : const Color(0xFF222222),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: dp(context, 52),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse, // allow mouse drag on web
          },
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(), // smooth bounce scroll
          padding: EdgeInsets.symmetric(horizontal: dp(context, 16)),
          children: [
            SizedBox(width: dp(context, 4)),
            chip('All Categories', selected == Category.all,
                () => context.read<HomeController>().setCategory(Category.all)),
            SizedBox(width: dp(context, 8)),
            chip('Men’s T-Shirt', selected == Category.mensTShirt,
                () => context.read<HomeController>().setCategory(Category.mensTShirt)),
            SizedBox(width: dp(context, 8)),
            chip('Men’s Shoes', selected == Category.mensShoes,
                () => context.read<HomeController>().setCategory(Category.mensShoes)),
            SizedBox(width: dp(context, 8)),
            chip('Limited', selected == Category.limited,
                () => context.read<HomeController>().setCategory(Category.limited)),
            SizedBox(width: dp(context, 4)),
          ],
        ),
      ),
    );
  }
}
