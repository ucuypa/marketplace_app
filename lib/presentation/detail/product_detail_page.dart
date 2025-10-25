import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';
import '../home/models/product.dart';

// widgets
import '../detail/widgets/detail_app_bar.dart';
import '../detail/widgets/product_hero.dart';
import '../detail/widgets/section_card.dart';
import '../detail/widgets/color_selector.dart';
import '../detail/widgets/size_selector.dart';
import '../detail/widgets/price_cta_bar.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _selectedColor;
  String? _selectedSize;

  List<String> _sizesFor(Product p) =>
      p.categories.contains(Category.mensShoes)
          ? const ['38', '39', '40', '41', '42', '43']
          : const ['S', 'M', 'L', 'XL'];

  final List<ColorOption> _colorOptions = const [
    ColorOption('Blue', Color(0xFF5B9EE1)),
    ColorOption('Black', Color(0xFF222222)),
    ColorOption('White', Color(0xFFFFFFFF), border: Color(0xFFDEE2E6)),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = _colorOptions.first.label;
    _selectedSize = _sizesFor(widget.product).first;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
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
                      DetailAppBar(onBack: () => Navigator.pop(ctx)),
                      ProductHero(imageAsset: p.imageAsset),
                      SizedBox(height: dp(ctx, 16)),
                      SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BEST SELLER',
                                style: inter(ctx, 12, w: FontWeight.w600, color: kPrimary)),
                            SizedBox(height: dp(ctx, 6)),
                            Text(p.title,
                                style: inter(ctx, 22, w: FontWeight.w700, color: kTextPrimary)),
                            SizedBox(height: dp(ctx, 6)),
                            Text(p.priceText,
                                style: inter(ctx, 16, w: FontWeight.w600, color: kTextPrimary)),
                            SizedBox(height: dp(ctx, 8)),
                            Text(
                              'Premium product with comfort-focused design. '
                              'Lightweight, breathable, and ready for daily wear.',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: inter(ctx, 13, w: FontWeight.w400, color: kTextMuted, h: 1.4),
                            ),
                            SizedBox(height: dp(ctx, 16)),

                            // Color
                            ColorSelector(
                              options: _colorOptions,
                              selected: _selectedColor!,
                              onChanged: (v) => setState(() => _selectedColor = v),
                            ),
                            SizedBox(height: dp(ctx, 16)),

                            // Size
                            SizeSelector(
                              sizes: _sizesFor(p),
                              selected: _selectedSize!,
                              onChanged: (v) => setState(() => _selectedSize = v),
                            ),
                            SizedBox(height: dp(ctx, 16)),

                            // Price + CTA
                            PriceCtaBar(
                              priceText: p.priceText,
                              onAddToCart: () {
                                // TODO: integrate cart
                                Navigator.pop(ctx);
                              },
                            ),
                          ],
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
    );
  }
}
