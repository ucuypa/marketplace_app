import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../controllers/home_controller.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final home = context.read<HomeController>();

    // inisialisasi controller sekali saja
    _controller = TextEditingController(text: home.searchQuery);

    // setiap teks berubah -> update HomeController
    _controller.addListener(() {
      home.setSearchQuery(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // cukup watch supaya list product ter-filter, 
    // tapi JANGAN dipakai untuk buat controller baru
    context.watch<HomeController>();

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
            Expanded(
              child: TextField(
                controller: _controller,
                style: inter(
                  context,
                  14,
                  w: FontWeight.w400,
                  color: kTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  hintStyle: inter(
                    context,
                    14,
                    w: FontWeight.w400,
                    color: kTextMuted,
                  ),
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
