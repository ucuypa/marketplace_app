import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onChanged;
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Size', style: inter(context, 15, w: FontWeight.w600, color: kTextPrimary)),
          SizedBox(height: dp(context, 10)),
          Wrap(
            spacing: dp(context, 10),
            runSpacing: dp(context, 10),
            children: sizes.map((s) {
              final isSel = s == selected;
              return GestureDetector(
                onTap: () => onChanged(s),
                child: Container(
                  width: dp(context, 44),
                  height: dp(context, 44),
                  decoration: BoxDecoration(
                    color: isSel ? kPrimary : const Color(0xFFF2F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text(
                      s,
                      style: inter(context, 14,
                          w: FontWeight.w600, color: isSel ? Colors.white : kTextPrimary),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
}
