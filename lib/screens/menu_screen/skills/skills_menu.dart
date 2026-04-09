import 'dart:ui';

import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/services/skill_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillsMenu extends StatelessWidget {
  const SkillsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is! CharacterLoaded) return const SizedBox();
        final character = state.character;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: SkillService.allSkills.length,
          itemBuilder: (context, index) {
            final skill = SkillService.allSkills[index];
            final currentLevel = character.learnedSkills[skill.type.name] ?? 0;

            // Calculate current cost
            int upgradeCost = skill.baseCost;
            for (int i = 0; i < currentLevel; i++) {
              upgradeCost *= 2;
            }

            final isUnlocked = character.level >= skill.unlockLevel;
            final canAfford = character.skillPoints >= upgradeCost;

            return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.overlayDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                AppColors.panelBorder.withValues(alpha: 0.6)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (isUnlocked && canAfford)
                              ? () {
                                  context.read<CharacterBloc>().add(
                                      CharacterUpgradeSkill(
                                          skill.type.name, upgradeCost));
                                }
                              : () {},
                          borderRadius: BorderRadius.circular(12),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Left Section: Cost
                                Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: AppColors.panelBorder
                                              .withValues(alpha: 0.6)),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'SP $upgradeCost',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.bodyMediumPrimary
                                          .copyWith(
                                        color: canAfford
                                            ? AppColors.success
                                            : AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // Center Section: Info
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          skill.name,
                                          textAlign: TextAlign.center,
                                          style: AppTypography
                                              .titleMediumPrimary
                                              .copyWith(
                                            color: AppColors.accentYellow,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          SkillService.getSkillDescription(
                                              skill.type,
                                              level: currentLevel == 0
                                                  ? 1
                                                  : currentLevel),
                                          textAlign: TextAlign.center,
                                          style:
                                              AppTypography.bodyMediumPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Right Section: Level
                                Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color: AppColors.panelBorder
                                              .withValues(alpha: 0.6)),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'lvl. $currentLevel',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.bodyMediumPrimary
                                          .copyWith(
                                        color: currentLevel > 0
                                            ? AppColors.accentYellow
                                            : AppColors.primaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Lock Overlay
                    if (!isUnlocked)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock,
                                      color: AppColors.accentYellow, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${skill.unlockLevel} lvl',
                                    style: AppTypography.titleLargePrimary
                                        .copyWith(
                                      color: AppColors.accentYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ));
          },
        );
      },
    );
  }
}
