import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: dp(context, 120),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              top: dp(context, 36),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(dp(context, 48)),
                    topRight: Radius.circular(dp(context, 48)),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: dp(context, 18),
              left: dp(context, 30),
              right: dp(context, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _icon('assets/icon/Home.png', Icons.home_outlined, context),
                  _icon('assets/icon/Heart.png', Icons.favorite_border, context),
                  SizedBox(width: dp(context, 56)),
                   _icon('assets/icon/Notification.png', Icons.notifications_none, context),
                   _icon('assets/icon/Profile.png', Icons.person_outline, context),
                ],
              ),
            ),
            Positioned(
              bottom: dp(context, 52),
              child: Container(
                width: dp(context, 56),
                height: dp(context, 56),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(dp(context, 28)),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(.60),
                      blurRadius: dp(context, 24),
                      offset: Offset(0, dp(context, 8)),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset('assets/icon/CartMidNavbar.png',
                      width: dp(context, 24),
                      height: dp(context, 24),
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: dp(context, 22))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(String asset, IconData fallback, BuildContext ctx) => Image.asset(
        asset,
        width: dp(ctx, 24),
        height: dp(ctx, 24),
        errorBuilder: (_, __, ___) => Icon(fallback, size: dp(ctx, 22)),
      );
}
