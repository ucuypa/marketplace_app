import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Basis lebar desain (boleh kamu ganti 375/420 sesuai kebutuhan).
const double kDesignWidth = 420;

/// Builder untuk menyediakan scale [s], dp(), dan inter()
class Scale extends InheritedWidget {
  final double s;
  const Scale({super.key, required this.s, required super.child});

  static Scale of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Scale>()!;

  @override
  bool updateShouldNotify(covariant Scale old) => s != old.s;
}

/// Hitung scale dari lebar kontainer saat ini (clamp biar nyaman).
double calcScale(BoxConstraints c) =>
    (c.maxWidth / kDesignWidth).clamp(0.85, 1.35);

double dp(BuildContext context, double v) => v * Scale.of(context).s;

TextStyle inter(BuildContext context, double size,
        {FontWeight w = FontWeight.w400, Color? color, double? h}) =>
    GoogleFonts.inter(
        fontSize: size * Scale.of(context).s,
        fontWeight: w,
        color: color,
        height: h);
