// lib/presentation/profile/widgets/profile_seller_section.dart
import 'package:flutter/material.dart';
import '../../shared/scale.dart';

class ProfileSellerSection extends StatelessWidget {
  final TextEditingController storeNameController;
  final bool isEditing;
  final VoidCallback onGoToDashboard;

  const ProfileSellerSection({
    super.key,
    required this.storeNameController,
    required this.isEditing,
    required this.onGoToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGoToDashboard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.symmetric(
                vertical: dp(context, 14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Go to Seller Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
