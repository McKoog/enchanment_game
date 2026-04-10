import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/models/skills/skill_type.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/equip_slot.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/equipment_picker.dart';
import 'package:enchantment_game/services/armor_set_service.dart';
import 'package:enchantment_game/services/skill_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EquipZone extends StatefulWidget {
  const EquipZone({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<EquipZone> createState() => _EquipZoneState();
}

class _EquipZoneState extends State<EquipZone> {
  SelectedSlot _selectedSlot = SelectedSlot.none;

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
    return BlocBuilder<CharacterBloc, CharacterState>(builder: (context, state) {
      final character = state.character;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.panelBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.panelBorder),
          ),
          child: Column(
            children: [
              // Stats and Effects Section
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Stats Column
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Stats',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT Sans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _StatRow('Level', '${character.level}'),
                                    const SizedBox(height: 8),
                                    _StatRow('Experience', '${character.currentExp} / ${character.maxExp} exp'),
                                    const SizedBox(height: 8),
                                    _StatRow('Attack Damage', '${character.lowerDamage} - ${character.higherDamage}'),
                                    const SizedBox(height: 8),
                                    _StatRow('Attack Speed', character.attackSpeed.toStringAsFixed(2)),
                                    const SizedBox(height: 8),
                                    _StatRow('Crit Chance', '${character.critRate}%'),
                                    const SizedBox(height: 8),
                                    _StatRow('Crit Power', '${character.critPower}%'),
                                    const SizedBox(height: 8),
                                    _StatRow('Defense', '${character.defense}'),
                                    const SizedBox(height: 8),
                                    _StatRow('Health', '${character.health}'),
                                    const SizedBox(height: 8),
                                    _StatRow('HP Regen', '${character.totalHpRegen} / s'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Effects Column
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Effects',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT Sans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildEffectsList(character),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: AppColors.panelBorder, height: 1),
              // Equipment Slots Section (Single Row)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Currently equiped:",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PT Sans',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Select slot to equip available items from inventory",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontFamily: 'PT Sans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: EquipSlot(
                                  item: character.equippedHelmet,
                                  bgIconPath: 'assets/icons/stock_equip/equip_helmet_icon.png',
                                  isSelected: _selectedSlot == SelectedSlot.helmet,
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = SelectedSlot.helmet;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: EquipSlot(
                                  item: character.equippedChestplate,
                                  bgIconPath: 'assets/icons/stock_equip/equip_breastplate_icon.png',
                                  isSelected: _selectedSlot == SelectedSlot.chestplate,
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = SelectedSlot.chestplate;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: EquipSlot(
                                  item: character.equippedLeggings,
                                  bgIconPath: 'assets/icons/stock_equip/equip_leggings_icon.png',
                                  isSelected: _selectedSlot == SelectedSlot.leggings,
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = SelectedSlot.leggings;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: EquipSlot(
                                  item: character.equippedBoots,
                                  bgIconPath: 'assets/icons/stock_equip/equip_boots_icon.png',
                                  isSelected: _selectedSlot == SelectedSlot.boots,
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = SelectedSlot.boots;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: EquipSlot(
                                  item: character.equippedWeapon ?? ItemRegistry.fist,
                                  bgIconPath: 'assets/icons/stock_equip/equip_weapon_icon.png',
                                  isSelected: _selectedSlot == SelectedSlot.weapon,
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = SelectedSlot.weapon;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: AppColors.panelBorder, height: 1),
              // Equipment Picker Carousel
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EquipmentPicker(
                    key: ValueKey(_selectedSlot),
                    selectedSlot: _selectedSlot,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
