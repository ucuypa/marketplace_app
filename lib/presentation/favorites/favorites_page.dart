// lib/presentation/favorites/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import '../home/models/product.dart';
import 'application/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
              // gunakan Builder supaya kita punya ctx di DALAM Scale
              child: Builder(
                builder: (ctx) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar sederhana
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dp(ctx, 16),
                          vertical: dp(ctx, 8),
                        ),
                        child: Row(
                          children: [
                            _iconBtn(ctx,
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () => Navigator.pop(ctx)),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Favourite',
                                  style: inter(ctx, 16,
                                      w: FontWeight.w600, color: kTextPrimary),
                                ),
                              ),
                            ),
                            _iconBtn(ctx, icon: Icons.favorite_border),
                          ],
                        ),
                      ),

                      // Konten
                      Expanded(
                        child: Consumer<FavoritesController>(
                          builder: (_, fav, __) {
                            final items = fav.items;
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'No favorites yet',
                                  style: inter(ctx, 14,
                                      w: FontWeight.w500, color: kTextMuted),
                                ),
                              );
                            }

                            // Grid 2 kolom
                            return GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: dp(ctx, 16),
                                vertical: dp(ctx, 8),
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.92,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, i) =>
                                  _FavoriteCard(ctx: ctx, p: items[i]),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _iconBtn(BuildContext ctx, {required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dp(ctx, 40),
        height: dp(ctx, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(ctx, 12)),
        ),
        child: Icon(icon, size: dp(ctx, 18), color: kTextPrimary),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final BuildContext ctx;
  final Product p;
  const _FavoriteCard({required this.ctx, required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dp(ctx, 16)),
      ),
      padding: EdgeInsets.all(dp(ctx, 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // gambar
          Expanded(
            child: Center(
              child: Image.asset(
                p.imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.image, size: dp(ctx, 36)),
              ),
            ),
          ),
          SizedBox(height: dp(ctx, 8)),
          Text('BEST SELLER',
              style: inter(ctx, 11, w: FontWeight.w600, color: kPrimary)),
          SizedBox(height: dp(ctx, 4)),
          Text(p.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: inter(ctx, 14, w: FontWeight.w600, color: kTextPrimary)),
          SizedBox(height: dp(ctx, 4)),
          Text(p.priceText,
              style: inter(ctx, 13, w: FontWeight.w600, color: kTextPrimary)),
        ],
      ),
    );
  }
}
