import 'dart:math' as math;

import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/theme/enchanted_weapons_glow_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'attack_field/components/weapon_field.dart';

class DraggableWeaponSlot extends StatelessWidget {
  final bool isExpanded;
  final bool isDragging;
  final double attackCooldownProgress;
  final Weapon weapon;
  final AnimationController pulseController;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  const DraggableWeaponSlot({
    super.key,
    required this.isExpanded,
    required this.isDragging,
    required this.attackCooldownProgress,
    required this.weapon,
    required this.pulseController,
    required this.onExpand,
    required this.onCollapse,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    final characterAttackSpeed = context.read<CharacterBloc>().state.character.attackSpeed;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null) {
          if (details.primaryDelta! < -2 && !isExpanded) {
            onExpand();
          } else if (details.primaryDelta! > 2 && isExpanded) {
            onCollapse();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Arrows
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                final charState = context.watch<CharacterBloc>().state;
                final escapeTime = charState.character.escapeCooldownEndTime;
                final isAllowedToEscape = (escapeTime != null && DateTime.now().isAfter(escapeTime) || escapeTime == null);

                return Opacity(
                  opacity: isExpanded ? 0.75 : 1,
                  child: Transform.translate(
                    offset: Offset(0, isExpanded ? (pulseController.value * -5) : (-pulseController.value * 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(3, (index) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.overlayDark,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isExpanded
                                    ? isDragging || !isAllowedToEscape
                                        ? Icons.close
                                        : Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 24,
                                color: AppColors.error,
                              ),
                            ),
                            if (!isDragging && isAllowedToEscape)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.overlayDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Transform.rotate(
                                  angle: index == 1
                                      ? isExpanded
                                          ? 0.0
                                          : math.pi
                                      : 0,
                                  child: Icon(
                                    (index == 1)
                                        ? Icons.back_hand_outlined
                                        : isExpanded
                                            ? Icons.arrow_downward_rounded
                                            : Icons.arrow_upward_rounded,
                                    size: 24,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            if (!isDragging && isAllowedToEscape)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.overlayDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isExpanded ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  size: 24,
                                  color: AppColors.error,
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              },
            ),

            if (!isExpanded) const SizedBox(height: 8),

            // The actual slot
            Stack(
              alignment: Alignment.center,
              children: [
                // Base slot background
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.overlayVeryDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      (isDragging && attackCooldownProgress > 0) ? '$characterAttackSpeed/sec' : '',
                      style: AppTypography.bodySmallHighlight,
                    ),
                  ),
                ),

                // Red cooldown fill
                if (isDragging && attackCooldownProgress > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80 * attackCooldownProgress,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.75),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                    ),
                  ),

                // Draggable weapon when expanded
                if (isExpanded)
                  Draggable<String>(
                    data: 'weapon',
                    onDragStarted: onDragStarted,
                    onDragEnd: (_) => onDragEnded(),
                    feedback: Material(
                      color: AppColors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          if (weapon.enchantLevel > 0)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: weapon.enchantLevel > 20 ? enchantedWeaponsGlowColors[21] : enchantedWeaponsGlowColors[weapon.enchantLevel],
                                    blurRadius: weapon.enchantLevel * 2,
                                    spreadRadius: weapon.enchantLevel.toDouble(),
                                  )
                                ],
                              ),
                            ),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(weapon.image, gaplessPlayback: true, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                    childWhenDragging: const SizedBox(width: 80, height: 80),
                    // Weapon in slot with pulse and rotation animation
                    child: AnimatedBuilder(
                      animation: pulseController,
                      builder: (context, child) {
                        // Create a subtle scale animation (1.0 to 1.2)
                        final scale = 1.0 + (pulseController.value * 0.20);
                        // Create a subtle rotation animation (-5 degrees to 5 degrees)
                        final rotation = math.sin(pulseController.value * math.pi) * 0.1; // roughly 5 degrees in radians

                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(scale, scale)
                            ..rotateZ(rotation),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: WeaponField(
                              weapon: weapon,
                              showBackground: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Escape Cooldown Text
                if (isExpanded)
                  Builder(builder: (context) {
                    final state = context.watch<CharacterBloc>().state;
                    final escapeTime = state.character.escapeCooldownEndTime;
                    if (escapeTime != null && DateTime.now().isBefore(escapeTime)) {
                      final diff = escapeTime.difference(DateTime.now()).inSeconds + 1;
                      return IgnorePointer(
                        child: Text(
                          '$diff',
                          style: AppTypography.titleLargePrimary.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(color: AppColors.black, blurRadius: 4),
                              Shadow(color: AppColors.error, blurRadius: 10),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
