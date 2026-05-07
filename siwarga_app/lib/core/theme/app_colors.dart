import 'package:flutter/material.dart';

/// Token warna — mirror docs/design/DESIGN-TOKENS.md
abstract final class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color primary2 = Color(0xFF283593);
  static const Color primary3 = Color(0xFF3949AB);
  static const Color danger = Color(0xFFC62828);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);

  static const Color surfaceLight = Color(0xFFF0F2F8);
  static const Color surfaceDark = Color(0xFF0F1117);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1C1C2E);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, primary2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
