import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/equip_slot.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/equipment_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enchantment_game/theme/app_colors.dart';

class EquipZone extends StatefulWidget {
  const EquipZone({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<EquipZone> createState() => _EquipZoneState();
}

class _EquipZoneState extends State<EquipZone> {
  SelectedSlot _selectedSlot = SelectedSlot.none;

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
              // Stats Section
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatRow('Level', '${character.level}'),
                      _StatRow('Experience', '${character.currentExp} / ${character.maxExp} exp'),
                      _StatRow('Attack Damage', '${character.lowerDamage} - ${character.higherDamage}'),
                      _StatRow('Attack Speed', character.attackSpeed.toStringAsFixed(2)),
                      _StatRow('Defense', '${character.defense}'),
                      _StatRow('Health', '${character.health}'),
                      _StatRow('HP Regen', '${character.hpRegen} / s'),
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
