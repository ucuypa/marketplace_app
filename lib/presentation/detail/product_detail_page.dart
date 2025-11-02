import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';
import '../home/models/product.dart';
import '../cart/application/cart_controller.dart';
import '../cart/cart_page.dart';

// controller
import 'application/detail_controller.dart';

// widgets
import 'widgets/detail_app_bar.dart';
import 'widgets/product_hero.dart';
import 'widgets/section_card.dart';
import 'widgets/color_selector.dart';
import 'widgets/size_selector.dart';
import 'widgets/price_cta_bar.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailController(product),
      child: Scaffold(
        backgroundColor: kScaffoldBg,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final s = calcScale(c);
              return Scale(
                s: s,
                child: Builder(
                  builder: (ctx) => SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: dp(ctx, 24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<DetailController>(
                         builder: (_, vm, __) => DetailAppBar(
  onBack: () => Navigator.pop(ctx),
  title: vm.categoryTitle,     // atau title yang sudah kamu pakai
  product: vm.product,         // ⬅️ PASS product ke app bar
),
                          ),

                        // Hero image
                        Consumer<DetailController>(
                          builder: (_, vm, __) =>
                              ProductHero(imageAsset: vm.product.imageAsset),
                        ),

                        SizedBox(height: dp(ctx, 16)),

                        SectionCard(
                          child: Consumer<DetailController>(
                            builder: (context, vm, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vm.product.badge,
                                    style: inter(ctx, 12,
                                        w: FontWeight.w600, color: kPrimary)),
                                SizedBox(height: dp(ctx, 6)),
                                Text(vm.product.title,
                                    style: inter(ctx, 22,
                                        w: FontWeight.w700, color: kTextPrimary)),
                                SizedBox(height: dp(ctx, 6)),
                                Text(vm.product.priceText,
                                    style: inter(ctx, 16,
                                        w: FontWeight.w600, color: kTextPrimary)),
                                SizedBox(height: dp(ctx, 8)),
                                Text(
                                  vm.product.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: inter(ctx, 13,
                                      w: FontWeight.w400,
                                      color: kTextMuted,
                                      h: 1.4),
                                ),
                                SizedBox(height: dp(ctx, 16)),

                                // Color selector
                                ColorSelector(
                                  options: vm.colorOptions,
                                  selected: vm.selectedColor,
                                  onChanged: vm.setColor,
                                ),
                                SizedBox(height: dp(ctx, 16)),

                                // Size selector
                                SizeSelector(
                                  sizes: vm.sizes,
                                  selected: vm.selectedSize,
                                  onChanged: vm.setSize,
                                ),
                                SizedBox(height: dp(ctx, 16)),

                                // Price + CTA
                                PriceCtaBar(
  priceText: vm.product.priceText,
  onAddToCart: () {
    // ambil varian terpilih dari DetailController
    final size = vm.selectedSize;
    final color = vm.selectedColor;

    // masukkan ke cart
    context.read<CartController>().add(
      vm.product,
      size: size,
      color: color,
    );

    // arahkan ke CartPage
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  },
),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
