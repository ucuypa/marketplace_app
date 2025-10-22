import 'package:flutter/material.dart';
import '../../shared/scale.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});
  @override
  Widget build(BuildContext context) {
    final s = Scale.of(context).s;
    return SizedBox(
      height: dp(context, 52),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: dp(context, 16)),
        children: [
          SizedBox(width: dp(context, 4)),
          _ChipFilled('All Categories', scale: s),
          SizedBox(width: dp(context, 8)),
          _ChipOutline('Men’s T-Shirt', scale: s),
          SizedBox(width: dp(context, 8)),
          _ChipOutline('Men’s Shoes', scale: s),
          SizedBox(width: dp(context, 8)),
          _ChipOutline('Special Price', scale: s),
          SizedBox(width: dp(context, 4)),
        ],
      ),
    );
  }
}

class _ChipFilled extends StatelessWidget {
  final String label;
  final double scale;
  const _ChipFilled(this.label, {required this.scale});
  @override
  Widget build(BuildContext context) => Container(
        height: 32 * scale,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Center(
          child: Text(label,
              style: inter(context, 12,
                  w: FontWeight.w500, color: Colors.white)),
        ),
      );
}

class _ChipOutline extends StatelessWidget {
  final String label;
  final double scale;
  const _ChipOutline(this.label, {required this.scale});
  @override
  Widget build(BuildContext context) => Container(
        height: 32 * scale,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(width: 1, color: const Color(0xFFF1EEEF)),
        ),
        child: Center(
          child: Text(label,
              style:
                  inter(context, 12, w: FontWeight.w500, color: const Color(0xFF222222))),
        ),
      );
}
