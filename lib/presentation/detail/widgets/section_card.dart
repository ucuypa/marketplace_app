import 'package:flutter/material.dart';
import 'package:marketplace_app/presentation/shared/scale.dart';
import 'package:marketplace_app/presentation/shared/ui_constants.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: dp(context, 20)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(dp(context, 24)),
          ),
          child: Padding(
            padding: EdgeInsets.all(dp(context, 16)),
            child: child,
          ),
        ),
      );
}
