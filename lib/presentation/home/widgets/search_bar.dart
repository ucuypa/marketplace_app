import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
      child: Container(
        height: dp(context, 52),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(context, 50)),
        ),
        child: Row(
          children: [
            SizedBox(width: dp(context, 12)),
            Container(
              width: dp(context, 32),
              height: dp(context, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(context, 32)),
              ),
              child: Center(
                child: Image.asset('assets/icon/SearchIcon.png',
                    width: dp(context, 16),
                    height: dp(context, 16),
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.search, size: dp(context, 18))),
              ),
            ),
            SizedBox(width: dp(context, 12)),
            Text('Search Product',
                style:
                    inter(context, 14, w: FontWeight.w400, color: kTextMuted)),
          ],
        ),
      ),
    );
  }
}
