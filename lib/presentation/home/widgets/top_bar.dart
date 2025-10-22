import 'package:flutter/material.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
      child: Row(
        children: [
          _circleBtn(context,
              child: Image.asset('assets/icon/Home.png',
                  width: dp(context, 24),
                  height: dp(context, 24),
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.home_outlined, size: dp(context, 22)))),

          SizedBox(width: dp(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Location',
                    style: inter(context, 12,
                        w: FontWeight.w300, color: kTextMuted)),
                SizedBox(height: dp(context, 2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,
                        size: dp(context, 14), color: kTextPrimary),
                    SizedBox(width: dp(context, 6)),
                    Text('Brawijaya University',
                        style:
                            inter(context, 14, w: FontWeight.w500, color: kTextPrimary)),
                  ],
                ),
              ],
            ),
          ),

          Stack(
            clipBehavior: Clip.none,
            children: [
              _circleBtn(context,
                  child: Image.asset('assets/icon/AddCartTopRight.png',
                      width: dp(context, 24),
                      height: dp(context, 24),
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.favorite_border, size: dp(context, 22)))),
              Positioned(
                right: dp(context, 6),
                top: dp(context, 6),
                child: Container(
                  width: dp(context, 8),
                  height: dp(context, 8),
                  decoration:
                      const BoxDecoration(color: kDanger, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(BuildContext ctx, {required Widget child}) => Container(
        width: dp(ctx, 44),
        height: dp(ctx, 44),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(ctx, 44)),
        ),
        child: Center(child: child),
      );
}
