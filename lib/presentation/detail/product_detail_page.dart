import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';
import '../home/models/product.dart';
import '../cart/application/cart_controller.dart';
import '../cart/cart_page.dart';
import 'application/detail_controller.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/section_card.dart';
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
                            title: vm.categoryTitle,
                            product: vm.product,
                          ),
                        ),

                        // Hero Image (Network)
                        Consumer<DetailController>(
                          builder: (_, vm, __) {
                            final imageUrl = vm.product.imageAsset;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: dp(ctx, 20),
                              ),
                              child: Container(
                                height: dp(ctx, 240),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    dp(ctx, 24),
                                  ),
                                ),
                                child: (imageUrl.isEmpty)
                                    ? Icon(
                                        Icons.image_not_supported,
                                        size: dp(ctx, 40),
                                        color: Colors.grey,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        height: dp(ctx, 180),
                                        fit: BoxFit.contain,
                                        loadingBuilder: (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                        },
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_not_supported,
                                          size: dp(ctx, 40),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: dp(ctx, 16)),

                        SectionCard(
                          child: Consumer<DetailController>(
                            builder: (context, vm, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vm.product.badge,
                                  style: inter(
                                    ctx,
                                    12,
                                    w: FontWeight.w600,
                                    color: kPrimary,
                                  ),
                                ),
                                SizedBox(height: dp(ctx, 6)),
                                Text(
                                  vm.product.title,
                                  style: inter(
                                    ctx,
                                    22,
                                    w: FontWeight.w700,
                                    color: kTextPrimary,
                                  ),
                                ),
                                SizedBox(height: dp(ctx, 6)),
                                Text(
                                  vm.product.priceText,
                                  style: inter(
                                    ctx,
                                    16,
                                    w: FontWeight.w600,
                                    color: kTextPrimary,
                                  ),
                                ),
                                SizedBox(height: dp(ctx, 8)),
                                Text(
                                  vm.product.description,
                                  style: inter(
                                    ctx,
                                    13,
                                    w: FontWeight.w400,
                                    color: kTextMuted,
                                    h: 1.4,
                                  ),
                                ),
                                SizedBox(height: dp(ctx, 16)),

                                if (vm.sizes.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Select Size:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (vm.selectedSize != null)
                                        Text(
                                          "Stock: ${vm.stockForSelectedSize}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: dp(ctx, 8)),
                                  SizeSelector(
                                    sizes: vm.sizes,
                                    selected: vm.selectedSize,
                                    onChanged: vm.setSize,
                                  ),
                                  SizedBox(height: dp(ctx, 16)),
                                ],

                                PriceCtaBar(
                                  priceText: vm.product.priceText,
                                  onAddToCart: () {
                                    if (vm.sizes.isNotEmpty &&
                                        vm.selectedSize == null) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please select a size"),
                                        ),
                                      );
                                      return;
                                    }
                                    int availableStock = vm.sizes.isNotEmpty
                                        ? vm.stockForSelectedSize
                                        : vm.product.stock;

                                    if (availableStock <= 0) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text("Out of stock!"),
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<CartController>().add(
                                      vm.product,
                                      size: vm.selectedSize ?? '',
                                    );

                                    Navigator.of(ctx).push(
                                      MaterialPageRoute(
                                        builder: (_) => const CartPage(),
                                      ),
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
