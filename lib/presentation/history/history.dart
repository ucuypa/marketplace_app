import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Stream pesanan user yang sudah "completed"
  Stream<QuerySnapshot<Map<String, dynamic>>> _historyStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('orders')
        .where('buyerID', isEqualTo: user.uid)
        .orderBy('orderDate', descending: true)
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dp(ctx, 20),
                        vertical: dp(ctx, 12),
                      ),
                      child: Row(
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
                          Expanded(
                            child: Center(
                              child: Text(
                                'History',
                                style: inter(
                                  ctx,
                                  18,
                                  w: FontWeight.w600,
                                  color: kTextPrimary,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Icon(Icons.more_horiz, size: dp(ctx, 20)),
                          ),
                        ],
                      ),
                    ),

                    // LIST DARI FIRESTORE
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _historyStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Failed to load history: ${snapshot.error}',
                                style: inter(ctx, 14, color: Colors.redAccent),
                              ),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No orders yet',
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
                              final id = docs[index].id;

                              final orderCode =
                                  '#${id.substring(0, 6).toUpperCase()}';

                              // Ambil data dari field "preview" yang kita simpan saat checkout
                              final productName =
                                  data['previewProductName'] as String? ??
                                  'Unknown Product';
                              final imageUrl =
                                  data['previewProductImage'] as String?;

                              // Ambil total, bukan harga satuan, karena ini ringkasan order
                              final price = (data['totalAmountPaid'] ?? 0)
                                  .toDouble();

                              final completedAt =
                                  data['orderDate'] as Timestamp?;
                              final dateStr = completedAt != null
                                  ? _formatDateTime(completedAt.toDate())
                                  : '-';

                              return _HistoryCard(
                                imageUrl: imageUrl,
                                // fallback kalau imageUrl kosong / error
                                fallbackAsset: 'assets/image/shoes.png',
                                orderId: orderCode,
                                productName: productName,
                                quantity:
                                    1, // Ringkasan order selalu 1 entitas transaksi
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

                    // ===== PADDING BAWAH =====
                    SizedBox(height: dp(ctx, 24)),
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

// CARD UNTUK SATU ITEM HISTORY

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
          color: const Color(0xFFF8F9FA), // Warna lebih terang agar bersih
          borderRadius: BorderRadius.circular(dp(ctx, 16)),
        ),
        padding: EdgeInsets.all(dp(ctx, 12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: dp(ctx, 80),
              height: dp(ctx, 80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(ctx, 12)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(dp(ctx, 12)),
                child: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                        },
                        errorBuilder: (_, __, ___) => _fallbackIcon(ctx),
                      )
                    : Image.asset(
                        fallbackAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _fallbackIcon(ctx),
                      ),
              ),
            ),
            SizedBox(width: dp(ctx, 12)),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          orderId,
                          style: inter(ctx, 12, color: kTextMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: inter(
                          ctx,
                          14,
                          w: FontWeight.w600,
                          color: kPrimary, // Warna harga menonjol
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dp(ctx, 4)),

                  // Nama Produk
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: inter(
                      ctx,
                      15,
                      w: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),

                  SizedBox(height: dp(ctx, 12)),

                  // Baris Bawah: Waktu
                  Text(timeText, style: inter(ctx, 11, color: kTextMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackIcon(BuildContext ctx) =>
      Icon(Icons.image_not_supported, size: dp(ctx, 24), color: Colors.grey);
}
