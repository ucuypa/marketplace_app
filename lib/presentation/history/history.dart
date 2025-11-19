import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../history/history.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';

class historyPage extends StatelessWidget {
  const historyPage({super.key});

  // Stream pesanan user yang sudah "completed"
  Stream<QuerySnapshot<Map<String, dynamic>>> _historyStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // kalau belum login, stream kosong
      return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }

    return FirebaseFirestore.instance
        .collection('orders') // ganti sesuai nama koleksi kamu
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'completed') // hanya pesanan selesai
        .orderBy('completedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final s = calcScale(constraints);
            return Scale(
              s: s,
              child: Builder(
                builder: (ctx) => Column(
                  children: [
                    // ===== CUSTOM APP BAR =====
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dp(ctx, 20),
                        vertical: dp(ctx, 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              width: dp(ctx, 40),
                              height: dp(ctx, 40),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: dp(ctx, 18),
                                color: kTextPrimary,
                              ),
                            ),
                          ),
                          Text(
                            'History',
                            style: inter(
                              ctx,
                              18,
                              w: FontWeight.w600,
                              color: kTextPrimary,
                            ),
                          ),
                          // dummy supaya title tetap center
                          Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.more_horiz,
                              size: dp(ctx, 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ===== LIST DARI FIRESTORE =====
                    Expanded(
                      child: StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>>(
                        stream: _historyStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Failed to load history',
                                style:
                                inter(ctx, 14, color: Colors.redAccent),
                              ),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No completed orders yet',
                                style: inter(
                                  ctx,
                                  14,
                                  color: kTextPrimary.withOpacity(0.6),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: dp(ctx, 20),
                              vertical: dp(ctx, 8),
                            ),
                            itemBuilder: (context, index) {
                              final data = docs[index].data();

                              final orderCode =
                                  data['orderCode'] as String? ??
                                      '#INV-UNKNOWN';
                              final productName =
                                  data['productName'] as String? ??
                                      'Unknown Product';
                              final quantity =
                              (data['quantity'] ?? 1) as int;
                              final price =
                              (data['price'] ?? 0).toDouble();
                              final imageUrl =
                              data['imageUrl'] as String?;
                              final completedAt =
                              data['completedAt'] as Timestamp?;
                              final dateStr = completedAt != null
                                  ? _formatDateTime(completedAt.toDate())
                                  : '-';

                              return _HistoryCard(
                                imageUrl: imageUrl,
                                // fallback kalau imageUrl kosong / error
                                fallbackAsset: 'assets/image/shoes.png',
                                orderId: orderCode,
                                productName: productName,
                                quantity: quantity,
                                price: price,
                                timeText: dateStr,
                              );
                            },
                            separatorBuilder: (_, __) =>
                                SizedBox(height: dp(ctx, 16)),
                            itemCount: docs.length,
                          );
                        },
                      ),
                    ),

                    // ===== BUTTON BACK =====
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        dp(ctx, 24),
                        0,
                        dp(ctx, 24),
                        dp(ctx, 24),
                      ),
                      child: SizedBox(
                        height: dp(ctx, 56),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(dp(ctx, 30)),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Back',
                            style: inter(
                              ctx,
                              16,
                              w: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Format: "21:05  21-Dec-2020"
  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final mon = months[dt.month - 1];
    final year = dt.year.toString();
    return '$hh:$mm  $day-$mon-$year';
  }
}

// ===== CARD UNTUK SATU ITEM HISTORY =====

class _HistoryCard extends StatelessWidget {
  final String? imageUrl;
  final String fallbackAsset;
  final String orderId;
  final String productName;
  final int quantity;
  final double price;
  final String timeText;

  const _HistoryCard({
    required this.imageUrl,
    required this.fallbackAsset,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(dp(ctx, 30)),
        ),
        padding: EdgeInsets.all(dp(ctx, 14)),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: dp(ctx, 92),
              height: dp(ctx, 92),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(ctx, 24)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(dp(ctx, 24)),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                  imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _fallbackIcon(ctx),
                )
                    : Image.asset(
                  fallbackAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _fallbackIcon(ctx),
                ),
              ),
            ),
            SizedBox(width: dp(ctx, 14)),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Order : $orderId',
                          style: inter(ctx, 12, color: kTextPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: dp(ctx, 8)),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: inter(
                          ctx,
                          14,
                          w: FontWeight.w600,
                          color: kTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dp(ctx, 6)),
                  Text(
                    productName,
                    style: inter(
                      ctx,
                      16,
                      w: FontWeight.w700,
                      color: kTextPrimary,
                    ),
                  ),
                  SizedBox(height: dp(ctx, 2)),
                  Text(
                    '(${quantity}x)',
                    style: inter(ctx, 14, color: kTextPrimary),
                  ),
                  SizedBox(height: dp(ctx, 10)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      timeText,
                      style: inter(ctx, 14, color: kTextPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackIcon(BuildContext ctx) => Icon(
    Icons.image_not_supported,
    size: dp(ctx, 32),
  );
}
