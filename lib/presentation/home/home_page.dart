import 'package:flutter/material.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'widgets/top_bar.dart';
import 'widgets/search_bar.dart' as hp; // <-- alias agar tidak bentrok dgn Material SearchBar
import 'widgets/category_chips.dart';
import 'widgets/popular_row.dart';
import 'widgets/new_arrivals_card.dart';
import 'widgets/bottom_nav.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final s = calcScale(c);
            return Scale(
              s: s,
              // ==== penting: pakai Builder supaya ctx berada DI DALAM Scale ====
              child: Builder(
                builder: (ctx) => Stack(
                  children: [
                    // ===== CONTENT =====
                    Positioned.fill(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: dp(ctx, 120)),
                        children: [
                          SizedBox(height: dp(ctx, 12)),
                          const TopBar(),
                          SizedBox(height: dp(ctx, 24)),
                          const hp.SearchBar(), // pakai alias
                          SizedBox(height: dp(ctx, 18)),
                          const CategoryChips(),
                          SizedBox(height: dp(ctx, 12)),
                          const PopularRow(),
                          SizedBox(height: dp(ctx, 24)),
                          const NewArrivalsCard(),
                          SizedBox(height: dp(ctx, 72)),
                        ],
                      ),
                    ),
                    // ===== BOTTOM NAV + FAB =====
                    BottomNav(
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
