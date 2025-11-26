import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selected;
  final ValueChanged<String> onChanged;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: dp(context, 12),
      runSpacing: dp(context, 12),
      children: sizes.map((size) {
        final isSelected = size == selected;

        return GestureDetector(
          onTap: () => onChanged(size),
          child: Container(
            width: dp(context, 48),
            height: dp(context, 48),
            decoration: BoxDecoration(
              color: isSelected ? kPrimary : Colors.white,
              shape:
                  BoxShape.circle, // Atau rounded rectangle sesuai desain Anda
              border: Border.all(
                color: isSelected ? kPrimary : const Color(0xFFEAEAEA),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                size,
                style: inter(
                  context,
                  14,
                  w: FontWeight.w600,
                  color: isSelected ? Colors.white : kTextPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
