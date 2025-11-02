import 'package:flutter/material.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'widgets/cart_app_bar.dart';
import 'widgets/cart_list.dart';
import 'widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
              child: Builder(
                builder: (ctx) => Column(
                  children: [
                    CartAppBar(onBack: () => Navigator.pop(ctx)),
                    const Expanded(child: CartList()),
                    const CartSummary(),
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
