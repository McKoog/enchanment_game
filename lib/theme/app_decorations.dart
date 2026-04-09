import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  // Panels
  static final Decoration panel = BoxDecoration(
    color: AppColors.panelBackground,
    border: const Border.fromBorderSide(
      BorderSide(color: AppColors.panelBorder, width: 5),
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [BoxShadow(blurRadius: 15, spreadRadius: 0)],
  );

  // Attack Circle Field
  static const Decoration attackField = BoxDecoration(
    color: AppColors.attackFieldBackground,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        blurRadius: 30,
        spreadRadius: 15,
        color: AppColors.slotBackground,
      )
    ],
  );

  // Slots
  static final Decoration inventorySlot = BoxDecoration(
    color: AppColors.slotBackground,
    border: const Border.fromBorderSide(
      BorderSide(color: AppColors.panelBorder, width: 2),
    ),
    borderRadius: BorderRadius.circular(15),
  );

  static final Decoration enchantSlotDefault = BoxDecoration(
    color: AppColors.enchantSlotBackground,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.borderHighlight, width: 2),
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(blurRadius: 20, spreadRadius: 1, color: AppColors.enchantSlotBackground)
    ],
  );

  static final Decoration enchantSlotInserted = BoxDecoration(
    color: Color.lerp(AppColors.enchantSlotBackground, AppColors.white, 0.2),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.borderHighlight.withValues(alpha: 0.5), width: 1),
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(blurRadius: 20, spreadRadius: 5, color: AppColors.white)
    ],
  );

  static final Decoration enchantSlotProgress = BoxDecoration(
    color: AppColors.enchantSlotBackground,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        blurRadius: 25,
        spreadRadius: 2.5,
        color: AppColors.error.withValues(alpha: 0.25),
      )
    ],
  );

  static final Decoration enchantSlotSuccess = BoxDecoration(
    color: Color.lerp(AppColors.enchantSlotBackground, AppColors.success, 0.15),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 2, spreadRadius: 1, color: AppColors.success)],
  );

  static final Decoration enchantSlotFailed = BoxDecoration(
    color: Color.lerp(AppColors.enchantSlotBackground, AppColors.black, 0.15),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.overlayMedium, width: 2),
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [BoxShadow(blurRadius: 15, spreadRadius: 5, color: AppColors.black)],
  );

  // Bars
  static final Decoration playerHpBar = BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.playerHp.withValues(alpha: 0.4)),
      bottom: BorderSide(color: AppColors.playerHp.withValues(alpha: 0.4)),
    ),
    boxShadow: [
      BoxShadow(blurRadius: 5, spreadRadius: 0, color: AppColors.success.withValues(alpha: 0.6))
    ],
  );

  static final Decoration enemyHpBar = BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.enemyHp.withValues(alpha: 0.4)),
      bottom: BorderSide(color: AppColors.enemyHp.withValues(alpha: 0.4)),
    ),
    boxShadow: [
      BoxShadow(blurRadius: 5, spreadRadius: 0, color: AppColors.enemyHp.withValues(alpha: 0.6))
    ],
  );

  // Other components
  static final Decoration subtleYellowBorder = BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.borderHighlight),
      bottom: BorderSide(color: AppColors.borderHighlight),
    ),
    boxShadow: [
      BoxShadow(blurRadius: 5, spreadRadius: 0, color: AppColors.accentYellow.withValues(alpha: 0.1))
    ],
  );

  static final Decoration darkGlowBorder = BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.borderHighlight),
      bottom: BorderSide(color: AppColors.borderHighlight),
    ),
    boxShadow: [
      BoxShadow(blurRadius: 5, spreadRadius: 0, color: AppColors.overlayMedium)
    ],
  );
}
