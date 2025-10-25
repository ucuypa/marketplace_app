// import 'package:flutter/material.dart';
// import '../shared/scale.dart';
// import '../shared/ui_constants.dart';
// import 'models/product.dart';

// class ProductDetailPage extends StatefulWidget {
//   final Product product;
//   const ProductDetailPage({super.key, required this.product});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   String? _selectedColor;
//   String? _selectedSize;

//   // ----- Helpers -----
//   List<String> _sizesFor(Product p) {
//     if (p.categories.contains(Category.mensShoes)) {
//       return const ['38', '39', '40', '41', '42', '43'];
//     }
//     return const ['S', 'M', 'L', 'XL'];
//   }

//   final List<_ColorOpt> _colorOptions = const [
//     _ColorOpt('Blue', Color(0xFF5B9EE1)),
//     _ColorOpt('Black', Color(0xFF222222)),
//     _ColorOpt('White', Color(0xFFFFFFFF), border: Color(0xFFDEE2E6)),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _selectedColor = _colorOptions.first.label;
//     _selectedSize = _sizesFor(widget.product).first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final p = widget.product;

//     return Scaffold(
//       backgroundColor: kScaffoldBg,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, c) {
//             final s = calcScale(c);
//             return Scale(
//               s: s,
//               // ⬇️ pentiiiing: gunakan Builder agar dapat ctx di bawah Scale
//               child: Builder(
//                 builder: (ctx) => SingleChildScrollView(
//                   padding: EdgeInsets.only(bottom: dp(ctx, 24)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ----- AppBar -----
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: dp(ctx, 16), vertical: dp(ctx, 8)),
//                         child: Row(
//                           children: [
//                             _iconBtn(
//                               ctx,
//                               onTap: () => Navigator.pop(ctx),
//                               icon: Icons.arrow_back_ios_new_rounded,
//                             ),
//                             const Spacer(),
//                             _iconBtn(ctx, icon: Icons.lock_outline_rounded),
//                           ],
//                         ),
//                       ),

//                       // ----- Hero image/area -----
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(ctx, 20)),
//                         child: Container(
//                           height: dp(ctx, 240),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(dp(ctx, 24)),
//                           ),
//                           child: Center(
//                             child: Image.asset(
//                               p.imageAsset,
//                               height: dp(ctx, 180),
//                               fit: BoxFit.contain,
//                               errorBuilder: (_, __, ___) =>
//                                   Icon(Icons.image, size: dp(ctx, 40)),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: dp(ctx, 16)),

//                       // ----- Card content -----
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(ctx, 20)),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(dp(ctx, 24)),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(dp(ctx, 16)),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('BEST SELLER',
//                                     style: inter(ctx, 12,
//                                         w: FontWeight.w600, color: kPrimary)),
//                                 SizedBox(height: dp(ctx, 6)),
//                                 Text(p.title,
//                                     style: inter(ctx, 22,
//                                         w: FontWeight.w700,
//                                         color: kTextPrimary)),
//                                 SizedBox(height: dp(ctx, 6)),
//                                 Text(p.priceText,
//                                     style: inter(ctx, 16,
//                                         w: FontWeight.w600,
//                                         color: kTextPrimary)),
//                                 SizedBox(height: dp(ctx, 8)),
//                                 Text(
//                                   'Premium product with comfort-focused design. '
//                                   'Lightweight, breathable, and ready for daily wear.',
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: inter(ctx, 13,
//                                       w: FontWeight.w400,
//                                       color: kTextMuted,
//                                       h: 1.4),
//                                 ),
//                                 SizedBox(height: dp(ctx, 16)),

//                                 // ---------- Color selector ----------
//                                 Text('Color',
//                                     style: inter(ctx, 15,
//                                         w: FontWeight.w600,
//                                         color: kTextPrimary)),
//                                 SizedBox(height: dp(ctx, 10)),
//                                 Row(
//                                   children: _colorOptions
//                                       .map((opt) => _ColorChip(
//                                             label: opt.label,
//                                             color: opt.color,
//                                             border: opt.border,
//                                             selected:
//                                                 _selectedColor == opt.label,
//                                             onTap: () => setState(() {
//                                               _selectedColor = opt.label;
//                                             }),
//                                           ))
//                                       .toList(),
//                                 ),
//                                 SizedBox(height: dp(ctx, 16)),

//                                 // ---------- Size selector (dinamis) ----------
//                                 Text('Size',
//                                     style: inter(ctx, 15,
//                                         w: FontWeight.w600,
//                                         color: kTextPrimary)),
//                                 SizedBox(height: dp(ctx, 10)),
//                                 Wrap(
//                                   spacing: dp(ctx, 10),
//                                   runSpacing: dp(ctx, 10),
//                                   children: _sizesFor(p).map((sOpt) {
//                                     final selected = _selectedSize == sOpt;
//                                     return _SizeChip(
//                                       label: sOpt,
//                                       selected: selected,
//                                       onTap: () =>
//                                           setState(() => _selectedSize = sOpt),
//                                     );
//                                   }).toList(),
//                                 ),
//                                 SizedBox(height: dp(ctx, 16)),

//                                 // ---------- Price + CTA ----------
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Price',
//                                             style: inter(ctx, 12,
//                                                 w: FontWeight.w500,
//                                                 color: kTextMuted)),
//                                         SizedBox(height: dp(ctx, 4)),
//                                         Text(p.priceText,
//                                             style: inter(ctx, 18,
//                                                 w: FontWeight.w700,
//                                                 color: kTextPrimary)),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     _ctaButton(ctx,
//                                         label: 'Add To Cart', onTap: () {
//                                       // TODO: add to cart logic
//                                       Navigator.pop(ctx); // demo
//                                     }),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _iconBtn(BuildContext ctx,
//       {required IconData icon, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: dp(ctx, 40),
//         height: dp(ctx, 40),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(dp(ctx, 12)),
//         ),
//         child: Icon(icon, size: dp(ctx, 18), color: kTextPrimary),
//       ),
//     );
//   }

//   Widget _ctaButton(BuildContext ctx,
//       {required String label, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: dp(ctx, 48),
//         padding: EdgeInsets.symmetric(horizontal: dp(ctx, 20)),
//         decoration: BoxDecoration(
//           color: kPrimary,
//           borderRadius: BorderRadius.circular(dp(ctx, 16)),
//           boxShadow: [
//             BoxShadow(
//               color: kPrimary.withOpacity(.25),
//               blurRadius: dp(ctx, 16),
//               offset: Offset(0, dp(ctx, 8)),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(label,
//               style: inter(ctx, 15, w: FontWeight.w600, color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }

// class _ColorOpt {
//   final String label;
//   final Color color;
//   final Color? border;
//   const _ColorOpt(this.label, this.color, {this.border});
// }

// class _ColorChip extends StatelessWidget {
//   final String label;
//   final Color color;
//   final Color? border;
//   final bool selected;
//   final VoidCallback onTap;
//   const _ColorChip({
//     super.key,
//     required this.label,
//     required this.color,
//     this.border,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final ring = selected ? kPrimary : (border ?? Colors.transparent);
//     return Padding(
//       padding: EdgeInsets.only(right: dp(context, 10)),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Column(
//           children: [
//             Container(
//               width: dp(context, 28),
//               height: dp(context, 28),
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: ring,
//                   width: selected ? dp(context, 3) : dp(context, 1),
//                 ),
//               ),
//             ),
//             SizedBox(height: dp(context, 6)),
//             Text(label, style: inter(context, 11, color: kTextMuted)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SizeChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   const _SizeChip(
//       {super.key, required this.label, required this.selected, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: dp(context, 44),
//         height: dp(context, 44),
//         decoration: BoxDecoration(
//           color: selected ? kPrimary : const Color(0xFFF2F4F6),
//           borderRadius: BorderRadius.circular(999),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: inter(context, 14,
//                 w: FontWeight.w600, color: selected ? Colors.white : kTextPrimary),
//           ),
//         ),
//       ),
//     );
//   }
// }
