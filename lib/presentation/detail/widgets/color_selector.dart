import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';

class ColorOption {
  final String label;
  final Color color;
  final Color? border;
  const ColorOption(this.label, this.color, {this.border});
}

class ColorSelector extends StatelessWidget {
  final List<ColorOption> options;
  final String selected;
  final ValueChanged<String> onChanged;
  const ColorSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: _h(context)),
          SizedBox(height: dp(context, 10)),
          Row(
            children: options
                .map((opt) => _ColorChip(
                      label: opt.label,
                      color: opt.color,
                      border: opt.border,
                      selected: selected == opt.label,
                      onTap: () => onChanged(opt.label),
                    ))
                .toList(),
          ),
        ],
      );

  TextStyle _h(BuildContext c) =>
      inter(c, 15, w: FontWeight.w600, color: kTextPrimary);
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color? border;
  final bool selected;
  final VoidCallback onTap;
  const _ColorChip({
    required this.label,
    required this.color,
    this.border,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ring = selected ? kPrimary : (border ?? Colors.transparent);
    return Padding(
      padding: EdgeInsets.only(right: dp(context, 10)),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: dp(context, 28),
              height: dp(context, 28),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ring,
                  width: selected ? dp(context, 3) : dp(context, 1),
                ),
              ),
            ),
            SizedBox(height: dp(context, 6)),
            Text(label, style: inter(context, 11, color: kTextMuted)),
          ],
        ),
      ),
    );
  }
}
