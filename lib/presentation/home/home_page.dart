// lib/presentation/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/home_controller.dart';

import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'widgets/top_bar.dart';
import 'widgets/search_bar.dart' as hp;
import 'widgets/category_chips.dart';
import 'widgets/popular_row.dart';
import 'widgets/new_arrivals_card.dart';
import 'widgets/bottom_nav.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Scaffold(
        backgroundColor: kScaffoldBg,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, c) {
              final s = calcScale(c);
              return Scale(
                s: s,
                child: Builder(
                  builder: (ctx) => Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: dp(ctx, 100)),
                          child: Column(
                            children: [
                              SizedBox(height: dp(ctx, 12)),
                              const TopBar(),
                              SizedBox(height: dp(ctx, 24)),
                              const hp.SearchBar(),
                              SizedBox(height: dp(ctx, 18)),
                              const CategoryChips(),
                              SizedBox(height: dp(ctx, 12)),

                              Expanded(
                                child: Consumer<HomeController>(
                                  builder: (context, controller, child) {
                                    if (controller.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return ListView(
                                      children: [
                                        const NewArrivalsCard(),
                                        SizedBox(height: dp(ctx, 24)),
                                        PopularRow(),
                                        SizedBox(height: dp(ctx, 72)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      BottomNav(
                        onProfileTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
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
      ),
    );
  }
}
