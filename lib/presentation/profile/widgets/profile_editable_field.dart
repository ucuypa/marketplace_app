import 'package:flutter/material.dart';
import '../../shared/scale.dart';

class ProfileEditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool obscure;
  final String? hint;

  const ProfileEditableField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
    this.obscure = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: dp(context, 8)),
        TextField(
          controller: controller,
          obscureText: obscure,
          enabled: isEditing,
          readOnly: !isEditing,
          decoration: InputDecoration(
            hintText: isEditing ? hint : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: dp(context, 16),
              horizontal: dp(context, 16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
