// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() => runApp(const _App());

// class _App extends StatelessWidget {
//   const _App({super.key});
//   @override
//   Widget build(BuildContext context) {
//     const bg = Color(0xFFF8F9FA);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: bg,
//         textTheme: GoogleFonts.interTextTheme(),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const primary = Color(0xFF5B9EE1);
//     const textPrimary = Color(0xFF1A242F);
//     const textMuted = Color(0xFF707B81);
//     const danger = Color(0xFFF77165);

//     return Scaffold(
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, c) {
//             // scale dari desain 420, dibatasi supaya nyaman di layar besar/kecil
//             final s = (c.maxWidth / 420).clamp(0.85, 1.35);

//             double dp(double v) => v * s;
//             TextStyle inter(double size,
//                     {FontWeight w = FontWeight.w400, Color? color, double? h}) =>
//                 GoogleFonts.inter(
//                     fontSize: size * s, fontWeight: w, color: color, height: h);

//             return Stack(
//               children: [
//                 // ================= CONTENT =================
//                 Positioned.fill(
//                   child: ListView(
//                     padding: EdgeInsets.only(bottom: dp(120)),
//                     children: [
//                       SizedBox(height: dp(12)),

//                       // Top bar
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(20)),
//                         child: Row(
//                           children: [
//                             _circleBtn(
//                               size: dp(44),
//                               child: Image.asset(
//                                 'assets/icon/Home.png',
//                                 width: dp(24),
//                                 height: dp(24),
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (_, __, ___) =>
//                                     Icon(Icons.home_outlined, size: dp(22)),
//                               ),
//                             ),
//                             SizedBox(width: dp(16)),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text('Location',
//                                       style: inter(12,
//                                           w: FontWeight.w300,
//                                           color: textMuted)),
//                                   SizedBox(height: dp(2)),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.location_on,
//                                           size: dp(14), color: textPrimary),
//                                       SizedBox(width: dp(6)),
//                                       Text('Brawijaya University',
//                                           style: inter(14,
//                                               w: FontWeight.w500,
//                                               color: textPrimary)),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 _circleBtn(
//                                   size: dp(44),
//                                   child: Image.asset(
//                                     'assets/icon/AddCartTopRight.png',
//                                     width: dp(24),
//                                     height: dp(24),
//                                     errorBuilder: (_, __, ___) => Icon(
//                                         Icons.favorite_border,
//                                         size: dp(22)),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: dp(6),
//                                   top: dp(6),
//                                   child: Container(
//                                     width: dp(8),
//                                     height: dp(8),
//                                     decoration: const BoxDecoration(
//                                       color: danger,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: dp(24)),

//                       // Search
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(20)),
//                         child: Container(
//                           height: dp(52),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(dp(50)),
//                           ),
//                           child: Row(
//                             children: [
//                               SizedBox(width: dp(12)),
//                               _circleBtn(
//                                 size: dp(32),
//                                 bg: Colors.white,
//                                 child: Image.asset(
//                                   'assets/icon/SearchIcon.png',
//                                   width: dp(16),
//                                   height: dp(16),
//                                   errorBuilder: (_, __, ___) =>
//                                       Icon(Icons.search, size: dp(18)),
//                                 ),
//                               ),
//                               SizedBox(width: dp(12)),
//                               Text('Search Product',
//                                   style: inter(14,
//                                       w: FontWeight.w400, color: textMuted)),
//                             ],
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: dp(18)),

//                       // Chips
//                       SizedBox(
//                         height: dp(52),
//                         child: ListView(
//                           scrollDirection: Axis.horizontal,
//                           padding: EdgeInsets.symmetric(horizontal: dp(16)),
//                           children: [
//                             SizedBox(width: dp(4)),
//                             _ChipFilled('All Categories', scale: s),
//                             SizedBox(width: dp(8)),
//                             _ChipOutline('Men’s T-Shirt', scale: s),
//                             SizedBox(width: dp(8)),
//                             _ChipOutline('Men’s Shoes', scale: s),
//                             SizedBox(width: dp(8)),
//                             _ChipOutline('Special Price', scale: s),
//                             SizedBox(width: dp(4)),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: dp(12)),

//                       _sectionHeader('Popular Product', scale: s),
//                       SizedBox(height: dp(12)),

//                       // Popular row
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(20)),
//                         child: Row(
//                           children: [
//                             _popularCard(
//                               badge: 'BEST SELLER',
//                               title: 'Stussy Angel',
//                               price: '\$40.99',
//                               image: 'assets/image/stussy.png',
//                               onAdd: () {},
//                               scale: s,
//                               imageHeight: dp(92), // lebih besar
//                             ),
//                             SizedBox(width: dp(16)),
//                             _popularCard(
//                               badge: 'BEST SELLER',
//                               title: 'Nike Jordan',
//                               price: '\$59.99',
//                               image: 'assets/image/shoes.png',
//                               onAdd: () {},
//                               scale: s,
//                               imageHeight: dp(92),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: dp(24)),

//                       _sectionHeader('New Arrivals', scale: s),
//                       SizedBox(height: dp(12)),

//                       // New Arrival wide card
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: dp(20)),
//                         child: Container(
//                           height: dp(136),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(dp(16)),
//                           ),
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 left: dp(20),
//                                 top: dp(20),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('BEST CHOICE',
//                                         style: inter(12,
//                                             w: FontWeight.w500,
//                                             color: primary)
//                                           .copyWith(letterSpacing: 0.96)),
//                                     SizedBox(height: dp(2)),
//                                     Text('Nike Air Jordan',
//                                         style: inter(20,
//                                             w: FontWeight.w500,
//                                             color: textPrimary)),
//                                     SizedBox(height: dp(8)),
//                                     Text('\$97.69',
//                                         style: inter(16,
//                                             w: FontWeight.w500,
//                                             color: textPrimary)),
//                                   ],
//                                 ),
//                               ),
//                               Positioned(
//                                 right: dp(12),
//                                 top: dp(0),
//                                 bottom: dp(0),
//                                 child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Transform.rotate(
//                                     angle: -0.25,
//                                     child: Image.asset(
//                                       'assets/image/shoes.png',
//                                       width: dp(170),
//                                       fit: BoxFit.contain,
//                                       errorBuilder: (_, __, ___) => Icon(
//                                           Icons.image_not_supported,
//                                           size: dp(48)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: dp(72)),
//                     ],
//                   ),
//                 ),

//                 // ================= Bottom curved + FAB =================
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   child: SizedBox(
//                     height: dp(120),
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Positioned.fill(
//                           top: dp(36),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(dp(48)),
//                                 topRight: Radius.circular(dp(48)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: dp(18),
//                           left: dp(30),
//                           right: dp(30),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Image.asset('assets/icon/Home.png',
//                                   width: dp(24),
//                                   height: dp(24),
//                                   errorBuilder: (_, __, ___) =>
//                                       Icon(Icons.home_outlined, size: dp(22))),
//                               Image.asset('assets/icon/Heart.png',
//                                   width: dp(24),
//                                   height: dp(24),
//                                   errorBuilder: (_, __, ___) => Icon(
//                                       Icons.favorite_border,
//                                       size: dp(22))),
//                               SizedBox(width: dp(56)),
//                               Image.asset('assets/icon/Notification.png',
//                                   width: dp(24),
//                                   height: dp(24),
//                                   errorBuilder: (_, __, ___) => Icon(
//                                       Icons.notifications_none,
//                                       size: dp(22))),
//                               Image.asset('assets/icon/Profile.png',
//                                   width: dp(24),
//                                   height: dp(24),
//                                   errorBuilder: (_, __, ___) =>
//                                       Icon(Icons.person_outline, size: dp(22))),
//                             ],
//                           ),
//                         ),
//                         Positioned(
//                           bottom: dp(52),
//                           child: Container(
//                             width: dp(56),
//                             height: dp(56),
//                             decoration: BoxDecoration(
//                               color: primary,
//                               borderRadius: BorderRadius.circular(dp(28)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: primary.withOpacity(.60),
//                                   blurRadius: dp(24),
//                                   offset: Offset(0, dp(8)),
//                                 )
//                               ],
//                             ),
//                             child: Center(
//                               child: Image.asset('assets/icon/CartMidNavbar.png',
//                                   width: dp(24),
//                                   height: dp(24),
//                                   errorBuilder: (_, __, ___) => Icon(
//                                         Icons.shopping_bag_outlined,
//                                         color: Colors.white,
//                                         size: dp(22),
//                                       )),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // ================== Widgets & Chips ==================
// Widget _sectionHeader(String title, {double scale = 1}) {
//   const textPrimary = Color(0xFF1A242F);
//   const primary = Color(0xFF5B9EE1);

//   double dp(double v) => v * scale;

//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: dp(20)),
//     child: Row(
//       children: [
//         Text(title,
//             style: GoogleFonts.inter(
//               fontSize: 16 * scale,
//               fontWeight: FontWeight.w500,
//               color: textPrimary,
//               height: 1.5,
//             )),
//         const Spacer(),
//         Text('See all',
//             style: GoogleFonts.inter(
//               fontSize: 13 * scale,
//               fontWeight: FontWeight.w400,
//               color: primary,
//               height: 1.23,
//             )),
//       ],
//     ),
//   );
// }

// class _ChipFilled extends StatelessWidget {
//   final String label;
//   final double scale;
//   const _ChipFilled(this.label, {this.scale = 1});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 32 * scale,
//       padding:
//           EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
//       decoration: BoxDecoration(
//         color: const Color(0xFF222222),
//         borderRadius: BorderRadius.circular(9999),
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: GoogleFonts.inter(
//             fontSize: 12 * scale,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//             height: 1.6,
//             letterSpacing: -0.12,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ChipOutline extends StatelessWidget {
//   final String label;
//   final double scale;
//   const _ChipOutline(this.label, {this.scale = 1});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 32 * scale,
//       padding:
//           EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFAFAFA),
//         borderRadius: BorderRadius.circular(9999),
//         border: Border.all(width: 1, color: const Color(0xFFF1EEEF)),
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: GoogleFonts.inter(
//             fontSize: 12 * scale,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF222222),
//             height: 1.6,
//             letterSpacing: -0.12,
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _popularCard({
//   required String badge,
//   required String title,
//   required String price,
//   required String image,
//   required VoidCallback onAdd,
//   double scale = 1,
//   double imageHeight = 92,
// }) {
//   const textPrimary = Color(0xFF1A242F);
//   const primary = Color(0xFF5B9EE1);

//   double dp(double v) => v * scale;

//   return Expanded(
//     child: Container(
//       height: dp(201),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(dp(16)),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             left: dp(12),
//             top: dp(8),
//             right: dp(12),
//             child: SizedBox(
//               height: dp(92),
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Transform.rotate(
//                   angle: -0.25,
//                   child: Image.asset(
//                     image,
//                     height: imageHeight, // scalable
//                     fit: BoxFit.contain,
//                     errorBuilder: (_, __, ___) =>
//                         Icon(Icons.image_not_supported, size: dp(36)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: dp(12),
//             right: dp(12),
//             bottom: dp(12),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(badge,
//                           style: GoogleFonts.inter(
//                             fontSize: 12 * scale,
//                             fontWeight: FontWeight.w500,
//                             color: primary,
//                           )),
//                       SizedBox(height: dp(2)),
//                       Text(title,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.inter(
//                             fontSize: 16 * scale,
//                             fontWeight: FontWeight.w600,
//                             color: textPrimary,
//                           )),
//                       SizedBox(height: dp(6)),
//                       Text(price,
//                           style: GoogleFonts.inter(
//                             fontSize: 14 * scale,
//                             fontWeight: FontWeight.w500,
//                             color: textPrimary,
//                           )),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: dp(8)),
//                 _addBtn(onTap: onAdd, scale: scale),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _addBtn({required VoidCallback onTap, double scale = 1}) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 32 * scale,
//       height: 32 * scale,
//       decoration: BoxDecoration(
//         color: const Color(0xFF5B9EE1),
//         borderRadius: BorderRadius.circular(10 * scale),
//       ),
//       child: Center(
//         child: Image.asset(
//           'assets/icon/AddProduct2.png',
//           width: 16 * scale,
//           height: 16 * scale,
//           errorBuilder: (_, __, ___) =>
//               Icon(Icons.add, color: Colors.white, size: 18 * scale),
//         ),
//       ),
//     ),
//   );
// }

// Widget _circleBtn({Widget? child, double size = 44, Color bg = Colors.white}) {
//   return Container(
//     width: size,
//     height: size,
//     decoration:
//         BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size)),
//     child: Center(child: child),
//   );
// }
