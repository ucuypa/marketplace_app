import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/scale.dart';
import '../../shared/ui_constants.dart';
import '../controllers/home_controller.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final userRole = controller.userRole;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Jika user adalah 'buyer', jalankan fungsi becomeSeller
              if (userRole == 'buyer') {
                // Gunakan 'read' di dalam callback
                context.read<HomeController>().becomeSeller(context);
              }
            },
            child: _circleBtn(
              context,
              child: userRole == 'seller'
                  ? Icon(Icons.dashboard_rounded, size: dp(context, 22))
                  : Icon(Icons.storefront_rounded, size: dp(context, 22)),
            ),
          ),

          SizedBox(width: dp(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Location',
                  style: inter(
                    context,
                    12,
                    w: FontWeight.w300,
                    color: kTextMuted,
                  ),
                ),
                SizedBox(height: dp(context, 2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: dp(context, 14),
                      color: const Color.fromARGB(255, 248, 114, 101),
                    ),
                    SizedBox(width: dp(context, 6)),
                    Text(
                      'Brawijaya University ',
                      style: inter(
                        context,
                        14,
                        w: FontWeight.w500,
                        color: kTextPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: dp(context, 44)),
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
