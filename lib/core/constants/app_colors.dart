import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF050816);
  static const Color backgroundLight = Color(0xFF0B1026);
  static const Color surface = Color(0xFF111827);

  static const Color cyan = Color(0xFF00E5FF);
  static const Color cyanDark = Color(0xFF00B8D4);
  static const Color violet = Color(0xFFB388FF);
  static const Color electricBlue = Color(0xFF448AFF);

  static const Color white = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);

  static const Color favoriteRed = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static const Color glass = Color(0x33FFFFFF);
  static const Color glassStroke = Color(0x4DFFFFFF);

  static const Color cardBackground = Color(0x1AFFFFFF);
  static const Color shimmerBase = Color(0x1AFFFFFF);
  static const Color shimmerHighlight = Color(0x33FFFFFF);

  static const List<Color> primaryGradient = [cyan, violet];
  static const List<Color> backgroundGradient = [background, backgroundLight, surface];
  static const List<Color> overlayGradient = [Colors.transparent, Color(0xCC050816)];
}
