import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_state.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/blocs/equip_overlay_bloc/equip_overlay_state.dart';
import 'package:enchantment_game/theme/enchanted_weapons_glow_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EquippedItemsOverlay extends StatelessWidget {
  final OverlayType overlayType;
  final VoidCallback onItemInserted;
  final double slotSize;

  const EquippedItemsOverlay({
    super.key,
    required this.overlayType,
    required this.onItemInserted,
    required this.slotSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.overlayMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.panelBorder, width: 2),
      ),
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          final character = state.character;

          List<Widget> slots = [];

          if (overlayType == OverlayType.all ||
              overlayType == OverlayType.weapon) {
            slots.add(_OverlaySlot(
              item: character.equippedWeapon?.name == 'Fist'
                  ? null
                  : character.equippedWeapon,
              placeholderPath: 'assets/icons/stock_equip/equip_weapon_icon.png',
              slotType: ItemType.weapon,
              onItemInserted: onItemInserted,
              slotSize: slotSize,
            ));
          }
          if (overlayType == OverlayType.all ||
              overlayType == OverlayType.armor) {
            slots.addAll([
              _OverlaySlot(
                item: character.equippedHelmet,
                placeholderPath:
                    'assets/icons/stock_equip/equip_helmet_icon.png',
                slotType: ItemType.armor,
                armorType: ArmorType.helmet,
                onItemInserted: onItemInserted,
                slotSize: slotSize,
              ),
              _OverlaySlot(
                item: character.equippedChestplate,
                placeholderPath:
                    'assets/icons/stock_equip/equip_breastplate_icon.png',
                slotType: ItemType.armor,
                armorType: ArmorType.chestplate,
                onItemInserted: onItemInserted,
                slotSize: slotSize,
              ),
              _OverlaySlot(
                item: character.equippedLeggings,
                placeholderPath:
                    'assets/icons/stock_equip/equip_leggings_icon.png',
                slotType: ItemType.armor,
                armorType: ArmorType.leggings,
                onItemInserted: onItemInserted,
                slotSize: slotSize,
              ),
              _OverlaySlot(
                item: character.equippedBoots,
                placeholderPath:
                    'assets/icons/stock_equip/equip_boots_icon.png',
                slotType: ItemType.armor,
                armorType: ArmorType.boots,
                onItemInserted: onItemInserted,
                slotSize: slotSize,
              ),
            ]);
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 5,
              children: slots
                  .map((slot) =>
                      SizedBox(width: slotSize, height: slotSize, child: slot))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class _OverlaySlot extends StatelessWidget {
  final Item? item;
  final String placeholderPath;
  final ItemType slotType;
  final ArmorType? armorType;
  final VoidCallback onItemInserted;
  final double slotSize;

  const _OverlaySlot({
    required this.item,
    required this.placeholderPath,
    required this.slotType,
    this.armorType,
    required this.onItemInserted,
    required this.slotSize,
  });

  @override
  Widget build(BuildContext context) {
    final characterBloc = context.read<CharacterBloc>();
    final inventoryBloc = context.read<InventoryBloc>();
    final draggableBloc = context.read<DraggableItemsBloc>();
    final enchantBloc = context.read<EnchantBloc>();

    Weapon? weapon;
    Armor? armor;
    if (item != null && item!.type == ItemType.weapon) weapon = item as Weapon;
    if (item != null && item!.type == ItemType.armor) armor = item as Armor;

    int enchantLevel = 0;
    if (weapon != null) enchantLevel = weapon.enchantLevel;
    if (armor != null) enchantLevel = armor.enchantLevel;

    return DragTarget<Item>(
      onWillAcceptWithDetails: (details) {
        if (details.data.type != slotType) return false;
        if (slotType == ItemType.armor && armorType != null) {
          if (details.data is Armor) {
            return (details.data as Armor).armorType == armorType;
          }
          return false;
        }
        return true;
      },
      onAcceptWithDetails: (details) {
        final draggedItem = details.data;
        final isFromInventory =
            draggableBloc.state is DraggableItemsState$Dragged;

        if (isFromInventory) {
          final draggedState =
              draggableBloc.state as DraggableItemsState$Dragged;
          final draggedItemIndex = draggedState.itemInventoryIndex;

          inventoryBloc.add(InventoryEvent$RemoveItem(item: draggedItem));

          if (enchantBloc.state.insertedItem == draggedItem &&
              enchantBloc.state is! EnchantState$Result) {
            enchantBloc.add(EnchantEvent$ExtractItem());
          }

          if (item != null) {
            inventoryBloc.add(
                InventoryEvent$AddItemAt(item: item!, index: draggedItemIndex));
          }
        } else {
          return; // Not from inventory, ignore (e.g. from another overlay slot)
        }

        // Equip the new item
        if (draggedItem is Weapon) {
          characterBloc.add(CharacterEquipWeapon(draggedItem));
        } else if (draggedItem is Armor) {
          characterBloc.add(CharacterEquipArmor(draggedItem));
        }
      },
      builder: (context, candidateData, rejectedData) {
        final decoration = (weapon != null || armor != null)
            ? BoxDecoration(
                color: enchantLevel < 16
                    ? AppColors.slotBackground
                        .withValues(alpha: 1 - (0.0666 * enchantLevel))
                    : enchantLevel < 21
                        ? AppColors.slotBackground.withValues(
                            alpha: 0.5 - (0.06 * (enchantLevel % 16)))
                        : Colors.grey.shade900.withValues(alpha: 0.25),
                border: Border.fromBorderSide(BorderSide(
                    color: candidateData.isNotEmpty
                        ? AppColors.borderHighlight
                        : AppColors.panelBorder,
                    width: candidateData.isNotEmpty ? 3 : 2)),
                borderRadius: BorderRadius.circular(15),
                boxShadow: enchantLevel == 0
                    ? null
                    : enchantLevel > 20
                        ? [
                            BoxShadow(
                                color: enchantedWeaponsGlowColors[21],
                                spreadRadius: 0.3)
                          ]
                        : [
                            BoxShadow(
                                color: enchantedWeaponsGlowColors[enchantLevel],
                                spreadRadius: 0.3)
                          ])
            : BoxDecoration(
                color: AppColors.slotBackground,
                border: Border.fromBorderSide(
                  BorderSide(
                      color: candidateData.isNotEmpty
                          ? AppColors.borderHighlight
                          : AppColors.panelBorder,
                      width: candidateData.isNotEmpty ? 3 : 2),
                ),
                borderRadius: BorderRadius.circular(15),
              );

        Widget childWidget = Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: decoration,
              child: item != null
                  ? Draggable<Item>(
                      data: item,
                      feedback: Image.asset(
                        item!.image,
                        height: MediaQuery.of(context).size.height / 12,
                        width: MediaQuery.of(context).size.height / 12,
                      ),
                      childWhenDragging: const SizedBox(),
                      child: Image.asset(item!.image),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(placeholderPath),
                      ),
                    ),
            ),
            if ((weapon != null || armor != null) && enchantLevel > 0)
              Positioned(
                  right: 8,
                  bottom: 8,
                  child: Text(
                    "+$enchantLevel",
                    style: AppTypography.attributeLabel
                        .copyWith(fontSize: 10, color: AppColors.accentYellow),
                  )),
          ],
        );

        return childWidget;
      },
    );
  }
}
