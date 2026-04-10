import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/models/skills/skill_type.dart';
import 'package:enchantment_game/services/armor_set_service.dart';
import 'package:enchantment_game/services/skill_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'enchant_tabs_header.dart';

class EnchantStatsEffectsView extends StatefulWidget {
  const EnchantStatsEffectsView({super.key});

  @override
  State<EnchantStatsEffectsView> createState() => _EnchantStatsEffectsViewState();
}

class _EnchantStatsEffectsViewState extends State<EnchantStatsEffectsView> {
  EnchantTab _currentTab = EnchantTab.stats;

  List<Widget> _buildEffectsList(Character character) {
    final effects = <Widget>[];

    // Build skills section
    final learnedSkills = character.learnedSkills.entries.where((e) => e.value > 0).toList();
    if (learnedSkills.isNotEmpty) {
      effects.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Skills',
            style: TextStyle(
              color: AppColors.accentYellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'PT Sans',
            ),
          ),
        ),
      );

      for (final skillEntry in learnedSkills) {
        final skillType = SkillType.values.firstWhere((e) => e.name == skillEntry.key);
        final level = skillEntry.value;
        final description = SkillService.getSkillDescription(skillType, level: level);
        final skillName = SkillService.allSkills.firstWhere((s) => s.type == skillType).name;

        effects.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'PT Sans',
                  fontSize: 13,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: '$skillName (lvl. $level): ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      effects.add(const SizedBox(height: 8));
    }

    final setEffect = ArmorSetService.getEffect(character.activeSetType);

    if (setEffect != null) {
      final weapon = character.equippedWeapon ?? ItemRegistry.fist;
      effects.addAll(setEffect.buildActiveEffectsList(character.activeSetEnchantLevel, weapon));
    }

    final rarityEffectsWidgets = <Widget>[];
    for (final effect in RarityEffect.values) {
      final multiplier = character.getRarityEffectMultiplier(effect);
      if (multiplier > 0) {
        rarityEffectsWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              effect.getDescription(multiplier),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'PT Sans',
              ),
            ),
          ),
        );
      }
    }

    if (rarityEffectsWidgets.isNotEmpty) {
      effects.add(const SizedBox(height: 8));
      effects.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Rarity effects:',
            style: TextStyle(
              color: AppColors.accentYellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'PT Sans',
            ),
          ),
        ),
      );
      effects.addAll(rarityEffectsWidgets);
    }

    if (effects.isEmpty) {
      effects.add(const Text(
        'No active effects',
        style: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontFamily: 'PT Sans',
        ),
      ));
    }

    return effects;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        final character = state.character;

        return Container(
            decoration: BoxDecoration(
              color: AppColors.overlayMedium.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                  child: EnchantTabsHeader(
                    currentTab: _currentTab,
                    onTabChanged: (tab) {
                      setState(() {
                        _currentTab = tab;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    child: _currentTab == EnchantTab.stats
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                _StatRow('Level', '${character.level}'),
                                const SizedBox(height: 8),
                                _StatRow('Experience', '${character.currentExp} / ${character.maxExp} exp'),
                                const SizedBox(height: 8),
                                _StatRow('Attack Damage', '${character.lowerDamage.toStringAsFixed(2)} - ${character.higherDamage.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _StatRow('Attack Speed', character.attackSpeed.toStringAsFixed(2)),
                                const SizedBox(height: 8),
                                _StatRow('Crit Chance', '${character.critRate.toStringAsFixed(2)}%'),
                                const SizedBox(height: 8),
                                _StatRow('Crit Power', '${character.critPower.toStringAsFixed(2)}%'),
                                const SizedBox(height: 8),
                                _StatRow('Defense', '${character.defense}'),
                                const SizedBox(height: 8),
                                _StatRow('Health', '${character.health}'),
                                const SizedBox(height: 8),
                                _StatRow('HP Regen', '${character.totalHpRegen} / s'),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildEffectsList(character),
                            ),
                          ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontFamily: 'PT Sans',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
            fontFamily: 'PT Sans',
          ),
        ),
      ],
    );
  }
}
