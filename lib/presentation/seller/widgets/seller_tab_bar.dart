// lib/presentation/seller/widgets/seller_tab_bar.dart
import 'package:flutter/material.dart';

import '../../shared/scale.dart';

class SellerTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SellerTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab(context, 'Home', 0),
        _buildTab(context, 'Products', 1),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final bool isActive = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: dp(context, 8)),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.blueAccent : Colors.black87,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: dp(context, 24)),
              color: isActive ? Colors.blueAccent : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
