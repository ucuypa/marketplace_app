import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/shared/scale.dart';
import '../../../presentation/shared/ui_constants.dart';
import '../application/cart_controller.dart';
import '../models/cart_item.dart';

class CartItemRow extends StatelessWidget {
  final CartItem item;
  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartController>();

    // total per item (price * qty) & state tombol minus
    final double lineTotal = item.product.price * item.qty;
    final bool canDec = item.qty > 1;

    return Container(
      padding: EdgeInsets.all(dp(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dp(context, 16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Thumbnail ---
          Container(
            width: dp(context, 90),
            height: dp(context, 90),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(dp(context, 12)),
            ),
            child: Center(
              child: Image.asset(
                item.product.imageAsset,
                width: dp(context, 120),
                height: dp(context, 120),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: dp(context, 12)),

          // --- Title, line total, qty controls ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: inter(context, 14, w: FontWeight.w600, color: kTextPrimary),
                ),
                SizedBox(height: dp(context, 4)),

                // total per baris (price * qty)
                Text(
                  '\$${lineTotal.toStringAsFixed(2)}',
                  style: inter(context, 13, w: FontWeight.w600, color: kTextPrimary),
                ),
                SizedBox(height: dp(context, 8)),

                // qty controls (di bawah harga)
                Row(
                  children: [
                    _qtyBtn(
                      context,
                      Icons.remove,
                      canDec ? () => cart.dec(item) : null, // disabled saat qty==1
                      enabled: canDec,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dp(context, 10)),
                      child: Text(
                        '${item.qty}',
                        style: inter(context, 14, w: FontWeight.w600),
                      ),
                    ),
                    // tombol add pakai aset — tanpa container/border
                    _qtyAssetBtn(
                      context,
                      'assets/icon/AddCheckout.png',
                      () => cart.inc(item),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Kanan: Size di atas, delete di bawah ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.size ?? '',
                style: inter(context, 13, w: FontWeight.w600, color: kTextPrimary),
              ),
              SizedBox(height: dp(context, 16)),
              GestureDetector(
                onTap: () => cart.remove(item),
                child: Image.asset(
                  'assets/icon/Delete.png',
                  width: dp(context, 24),
                  height: dp(context, 24),
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.delete_outline, color: kDanger, size: dp(context, 22)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tombol qty dengan ikon Material (dipakai untuk minus)
  Widget _qtyBtn(BuildContext ctx, IconData ic, VoidCallback? onTap, {bool enabled = true}) {
    return GestureDetector(
      onTap: onTap, // null => tidak respons
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          width: dp(ctx, 28),
          height: dp(ctx, 28),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(ic, size: dp(ctx, 16), color: kTextPrimary),
        ),
      ),
    );
  }

  // Tombol qty dengan ikon aset (dipakai untuk plus) — TANPA background/container
  Widget _qtyAssetBtn(BuildContext ctx, String asset, VoidCallback onTap, {bool enabled = true}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: SizedBox(
          width: dp(ctx, 28),
          height: dp(ctx, 28),
          child: Center(
            child: Image.asset(
              asset,
              width: dp(ctx, 24),
              height: dp(ctx, 24),
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.add, size: dp(ctx, 16), color: kTextPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
