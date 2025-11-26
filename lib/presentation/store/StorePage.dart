import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import '../home/models/product.dart';
import '../detail/product_detail_page.dart';
import '../home/widgets/product_card.dart';

class StorePage extends StatelessWidget {
  final String sellerId;
  final String sellerName;
  final String? sellerImage;

  const StorePage({
    super.key,
    required this.sellerId,
    required this.sellerName,
    this.sellerImage,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _storeStream = FirebaseFirestore.instance
        .collection('items')
        .where('sellerID', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final s = calcScale(c);
            return Scale(
              s: s,
              child: Builder(
                builder: (ctx) => CustomScrollView(
                  slivers: [
                    // --- Sliver App Bar (Header) ---
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      expandedHeight: dp(ctx, 140),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: dp(ctx, 60),
                            bottom: dp(ctx, 20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Seller Avatar
                              Container(
                                width: dp(ctx, 60),
                                height: dp(ctx, 60),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                  image:
                                      sellerImage != null &&
                                          sellerImage!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(sellerImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child:
                                    sellerImage == null || sellerImage!.isEmpty
                                    ? Icon(
                                        Icons.storefront,
                                        size: dp(ctx, 30),
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              SizedBox(height: dp(ctx, 10)),
                              // Seller Name
                              Text(
                                sellerName,
                                style: TextStyle(
                                  fontSize: dp(ctx, 18),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // --- Product Grid ---
                    StreamBuilder<QuerySnapshot>(
                      stream: _storeStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Container(
                              height: 300,
                              alignment: Alignment.center,
                              child: const Text("This store has no items."),
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        return SliverPadding(
                          padding: EdgeInsets.all(dp(ctx, 20)),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: dp(ctx, 16),
                                  mainAxisSpacing: dp(ctx, 16),
                                  childAspectRatio: (160 / 210),
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final doc = docs[index];
                              final p = Product.fromFirestore(doc);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(product: p),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  product: p,
                                  imageHeight: 130 * s,
                                  onAdd: () {},
                                ),
                              );
                            }, childCount: docs.length),
                          ),
                        );
                      },
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
}
