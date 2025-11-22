import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/scale.dart';
import '../shared/ui_constants.dart';
import 'address_model.dart';
import 'add_edit_address_page.dart';

class AddressListPage extends StatelessWidget {
  // ⭐️ 1. Add this parameter
  final bool isSelectionMode;

  // ⭐️ 2. Update the constructor
  const AddressListPage({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        // ⭐️ 3. Dynamic Title
        title: Text(
          isSelectionMode ? 'Select Address' : 'Home Address',
          style: const TextStyle(
            color: kTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kScaffoldBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final s = calcScale(c);
            return Scale(
              s: s,
              child: Builder(
                builder: (ctx) => Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: addressStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No addresses yet.',
                                style: inter(ctx, 14, color: kTextMuted),
                              ),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          return ListView.separated(
                            padding: EdgeInsets.all(dp(ctx, 20)),
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: dp(ctx, 16)),
                            itemBuilder: (context, index) {
                              final address = AddressModel.fromFirestore(
                                docs[index],
                              );

                              // ⭐️ 4. Wrap card in GestureDetector for selection
                              return GestureDetector(
                                onTap: () {
                                  if (isSelectionMode) {
                                    // Return the address to CheckoutPage
                                    Navigator.pop(context, address);
                                  }
                                },
                                child: _AddressCard(
                                  ctx: ctx,
                                  address: address,
                                  isSelectionMode:
                                      isSelectionMode, // Pass mode down
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Add New Address Button (Visible in both modes)
                    Padding(
                      padding: EdgeInsets.all(dp(ctx, 20)),
                      child: SizedBox(
                        width: double.infinity,
                        height: dp(ctx, 50),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddEditAddressPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.blueAccent,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(dp(ctx, 25)),
                            ),
                            backgroundColor: Colors.blue.shade50,
                          ),
                          child: Text(
                            'Add New Address',
                            style: inter(
                              ctx,
                              16,
                              w: FontWeight.w600,
                              color: kTextPrimary,
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
}

class _AddressCard extends StatelessWidget {
  final BuildContext ctx;
  final AddressModel address;
  final bool isSelectionMode; // ⭐️ 5. Add parameter here too

  const _AddressCard({
    required this.ctx,
    required this.address,
    required this.isSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dp(ctx, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dp(ctx, 12)),
        border: Border.all(
          // ⭐️ 6. Highlight border if in selection mode
          color: isSelectionMode
              ? Colors.blueAccent.withOpacity(0.5)
              : Colors.grey.shade300,
          width: isSelectionMode ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.name,
            style: inter(ctx, 14, w: FontWeight.w600, color: kTextPrimary),
          ),
          SizedBox(height: dp(ctx, 4)),
          Text(
            address.phone,
            style: inter(ctx, 13, w: FontWeight.w400, color: kTextPrimary),
          ),
          SizedBox(height: dp(ctx, 4)),
          Text(
            address.street,
            style: inter(ctx, 13, w: FontWeight.w400, color: kTextPrimary),
          ),
          Text(
            '${address.city}, ${address.zip}',
            style: inter(ctx, 13, w: FontWeight.w400, color: kTextPrimary),
          ),

          // ⭐️ 7. Hide 'Edit' button in selection mode to prevent confusion
          if (!isSelectionMode) ...[
            SizedBox(height: dp(ctx, 12)),
            SizedBox(
              width: double.infinity,
              height: dp(ctx, 36),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditAddressPage(address: address),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(dp(ctx, 8)),
                  ),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: kTextPrimary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
