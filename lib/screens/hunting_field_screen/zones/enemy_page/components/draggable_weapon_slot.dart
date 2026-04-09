import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/components/weapon_field.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/theme/enchanted_weapons_glow_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
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
        child: Row(
          children: [
            // Animated Arrows
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(isExpanded ? (pulseController.value * 5) : (-pulseController.value * 15), 0),
                  child: Column(
                    children: [
                      Text(isExpanded ? '>>>>>>' : '<<<<<<', style: AppTypography.attributeLabel.copyWith(color: AppColors.error)),
                      Text(isExpanded ? '>>>>>>' : '<<<<<<', style: AppTypography.attributeLabel.copyWith(color: AppColors.error)),
                      Text(isExpanded ? '>>>>>>' : '<<<<<<', style: AppTypography.attributeLabel.copyWith(color: AppColors.error)),
                    ],
                  ),
                );
              },
            ),
            // Silhouette when collapsed
            if (!isExpanded)
              ColorFiltered(
                colorFilter: const ColorFilter.mode(AppColors.error, BlendMode.srcIn),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/icons/slot_slider_icon.png', gaplessPlayback: true, fit: BoxFit.contain),
                ),
              ),

            if (!isExpanded) const SizedBox(width: 8),

            // The actual slot
            Stack(
              alignment: Alignment.center,
              children: [
                // Base slot background
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.panelBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      (isDragging && attackCooldownProgress > 0) ? '${weapon.attackSpeed}/sec' : '',
                      style: AppTypography.bodySmallHighlight,
                    ),
                  ),
                ),

                // Yellow cooldown fill (red here technically)
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
                    // Empty slot
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: WeaponField(
                        weapon: weapon,
                        showBackground: false,
                      ),
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
