import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart'; // Ensure 'inter' is defined here
import '../controllers/home_controller.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    // ⬅️ This is now a String? (null means 'All')
    final selected = context.watch<HomeController>().selectedCategory;

    Widget chip(String label, String? categoryValue, VoidCallback onTap) {
      // Check if this chip is selected
      final isSelected = selected == categoryValue;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32 * s,
          padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 12 * s),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF222222)
                : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(9999),
            border: isSelected
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
                color: isSelected ? Colors.white : const Color(0xFF222222),
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
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: dp(context, 16)),
          children: [
            SizedBox(width: dp(context, 4)),
            // 'All' passes null
            chip(
              'All Categories',
              null,
              () => context.read<HomeController>().setCategory(null),
            ),
            SizedBox(width: dp(context, 8)),
            chip(
              'T-Shirt',
              'T-Shirt',
              () => context.read<HomeController>().setCategory('T-Shirt'),
            ),
            SizedBox(width: dp(context, 8)),
            chip(
              'Shoes',
              'Shoes',
              () => context.read<HomeController>().setCategory('Shoes'),
            ),
            SizedBox(width: dp(context, 8)),
            chip(
              'Sandals',
              'Sandals',
              () => context.read<HomeController>().setCategory('Sandals'),
            ),
            SizedBox(width: dp(context, 4)),
          ],
        ),
      ),
    );
  }
}
