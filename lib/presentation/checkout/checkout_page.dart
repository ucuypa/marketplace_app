import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/ui_constants.dart';
import '../shared/scale.dart';
import '../cart/application/cart_controller.dart';
import '../cart/models/courier_model.dart'; // Import the courier model
import '../address_user/address_model.dart';
import '../address_user/address_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We use Consumer to rebuild when Address or Courier changes
    return Consumer<CartController>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: kScaffoldBg,
          appBar: AppBar(
            title: const Text(
              "Checkout",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: cart.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. ADDRESS SECTION
                      const Text(
                        "Shipping Address",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          // Navigate to Address List in Selection Mode
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AddressListPage(isSelectionMode: true),
                            ),
                          );

                          // Update Controller
                          if (result != null && result is AddressModel) {
                            cart.setAddress(result);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: cart.selectedAddress == null
                              ? const Row(
                                  children: [
                                    Icon(
                                      Icons.add_location_alt_outlined,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Select Delivery Address",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: kPrimary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          cart.selectedAddress!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cart.selectedAddress!.street,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "${cart.selectedAddress!.city}, ${cart.selectedAddress!.zip}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Shipping Method",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: kCouriers.map((courier) {
                            return RadioListTile<CourierModel>(
                              title: Text(
                                "${courier.name} - ${courier.service}",
                              ),
                              subtitle: Text("Est: ${courier.estimate}"),
                              secondary: Text(
                                "\$${courier.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              value: courier,
                              groupValue: cart.selectedCourier,
                              activeColor: kPrimary,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                cart.setCourier(val);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3. ORDER SUMMARY
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: "Items Total",
                              value: cart.subtotal,
                            ),
                            _SummaryRow(
                              label: "Shipping",
                              value: cart.shippingCost,
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "\$${cart.total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Add space for button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

          // 4. PAY BUTTON
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: SafeArea(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: cart.isLoading
                    ? null
                    : () async {
                        try {
                          await cart.checkout("Credit Card");

                          if (context.mounted) {
                            // Go back to home
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Order Placed Successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: Text(
                  cart.isLoading
                      ? "Processing..."
                      : "Pay \$${cart.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text("\$${value.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}
