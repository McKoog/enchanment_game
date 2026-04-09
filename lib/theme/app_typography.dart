import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamily = "PT Sans";

  // Extremely Large
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 30, color: AppColors.highlightText, fontFamily: _fontFamily,
  );

  // Titles (Size 26)
  static const TextStyle titleLargeHighlight = TextStyle(
    fontSize: 26, color: AppColors.highlightText, fontFamily: _fontFamily,
  );
  static const TextStyle titleLargePrimary = TextStyle(
    fontSize: 26, color: AppColors.primaryText, fontFamily: _fontFamily,
  );
  static const TextStyle titleLargeDark = TextStyle(
    fontSize: 26, color: AppColors.darkText, fontFamily: _fontFamily,
  );
  static const TextStyle titleLargeSecondary = TextStyle(
    fontSize: 26, color: AppColors.secondaryText, fontFamily: _fontFamily,
  );

  // Medium Titles (Size 22)
  static const TextStyle titleMediumHighlight = TextStyle(
    fontSize: 22, color: AppColors.highlightText, fontFamily: _fontFamily,
  );
  static const TextStyle titleMediumPrimary = TextStyle(
    fontSize: 22, color: AppColors.primaryText, fontFamily: _fontFamily,
  );
  static const TextStyle titleMediumDark = TextStyle(
    fontSize: 22, color: AppColors.darkText, fontFamily: _fontFamily,
  );
  static const TextStyle titleMediumSecondary = TextStyle(
    fontSize: 22, color: AppColors.secondaryText, fontFamily: _fontFamily,
  );

  // Small Titles / Large Body (Size 20)
  static const TextStyle titleSmallPrimary = TextStyle(
    fontSize: 20, color: AppColors.primaryText, fontFamily: _fontFamily,
  );

  // Regular Body (Size 18)
  static const TextStyle bodyLargePrimary = TextStyle(
    fontSize: 18, color: AppColors.primaryText, fontFamily: _fontFamily,
  );
  static const TextStyle bodyLargeHighlight = TextStyle(
    fontSize: 18, color: AppColors.highlightText, fontFamily: _fontFamily,
  );

  // Normal Body (Size 16)
  static TextStyle bodyMediumPrimary = TextStyle(
    fontSize: 16, color: AppColors.primaryText.withValues(alpha: 0.9), fontFamily: _fontFamily,
  );

  // Small Body (Size 15)
  static const TextStyle bodySmallPrimary = TextStyle(
    fontSize: 15, color: AppColors.primaryText, fontFamily: _fontFamily,
  );

  static const TextStyle bodySmallHighlight = TextStyle(
    fontSize: 14, color: AppColors.accentYellow, fontFamily: _fontFamily,
  );

  static const TextStyle attributeLabel = TextStyle(
    fontSize: 12, color: AppColors.secondaryText, fontFamily: _fontFamily,
  );
}
