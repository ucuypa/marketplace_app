import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                // ⬅️ tambah
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../controllers/home_controller.dart';          // ⬅️ tambah

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<HomeController>().searchQuery; // ⬅️ baca state

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
                child: Image.asset(
                  'assets/icon/SearchIcon.png',
                  width: dp(context, 16),
                  height: dp(context, 16),
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.search, size: dp(context, 18)),
                ),
              ),
            ),
            SizedBox(width: dp(context, 12)),
            // ⬇️ ganti Text jadi TextField supaya bisa ketik
            Expanded(
              child: TextField(
                onChanged: context.read<HomeController>().setSearchQuery, // ⬅️ kirim event
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                style: inter(context, 14,
                    w: FontWeight.w400, color: kTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  hintStyle: inter(context, 14,
                      w: FontWeight.w400, color: kTextMuted),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: dp(context, 14),
                  ),
                ),
              ),
            ),
            SizedBox(width: dp(context, 12)),
          ],
        ),
      ),
    );
  }
}
