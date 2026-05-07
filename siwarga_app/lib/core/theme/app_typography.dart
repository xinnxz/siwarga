import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextTheme appTextTheme(Brightness brightness) {
  final base = GoogleFonts.poppinsTextTheme();
  final color =
      brightness == Brightness.dark ? Colors.white70 : const Color(0xFF333333);
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(color: color),
    displayMedium: base.displayMedium?.copyWith(color: color),
    displaySmall: base.displaySmall?.copyWith(color: color),
    headlineLarge: base.headlineLarge?.copyWith(
      color: color,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      color: color,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: base.titleLarge?.copyWith(
      color: color,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: base.bodyLarge?.copyWith(color: color),
    bodyMedium: base.bodyMedium?.copyWith(color: color),
    labelLarge: base.labelLarge?.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),
  );
}
