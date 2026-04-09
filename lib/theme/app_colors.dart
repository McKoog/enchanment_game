import 'package:flutter/material.dart';

class AppColors {
  // Primary semantic colors
  static const Color primaryText = Colors.white;
  static const Color highlightText = Colors.yellow;
  static const Color secondaryText = Colors.grey;
  static const Color darkText = Colors.black;

  // UI Panels and Zones
  static const Color panelBackground = Color.fromRGBO(78, 78, 78, 1);
  static const Color panelBorder = Color.fromRGBO(130, 130, 130, 1);
  static const Color attackFieldBackground = Color.fromRGBO(100, 100, 100, 1);
  static final Color overlayLight = Colors.black.withValues(alpha: 0.3);
  static final Color overlayMedium = Colors.black.withValues(alpha: 0.5);
  static final Color overlayDark = Colors.black.withValues(alpha: 0.7);
  static final Color overlayVeryDark = Colors.black.withValues(alpha: 0.85);
  static final Color borderHighlight = Colors.yellow.withValues(alpha: 0.5);
  static const Color accentYellow = Colors.yellow;

  // Slots
  static const Color slotBackground = Color.fromRGBO(85, 85, 85, 1);
  static const Color enchantSlotBackground = Color.fromRGBO(70, 70, 70, 1);

  // HP and Combat
  static final Color playerHp = Colors.green.shade900;
  static const Color enemyHp = Color.fromRGBO(212, 0, 0, 1);
  static final Color playerHpText = Colors.green.shade300;
  static final Color enemyHpText = Colors.red.shade300;

  // States
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;

  // Generic
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
}
