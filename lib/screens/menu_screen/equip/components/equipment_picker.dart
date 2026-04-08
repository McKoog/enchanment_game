import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/item_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SelectedSlot { none, weapon, helmet, chestplate, leggings, boots }

class EquipmentPicker extends StatefulWidget {
  const EquipmentPicker({
    super.key,
    required this.selectedSlot,
  });

  final SelectedSlot selectedSlot;

  @override
  State<EquipmentPicker> createState() => _EquipmentPickerState();
}

class _EquipmentPickerState extends State<EquipmentPicker> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    // Calculate initial item
    int initialIndex = 0;
    if (widget.selectedSlot != SelectedSlot.none) {
      final inventoryBloc = context.read<InventoryBloc>();
      final characterBloc = context.read<CharacterBloc>();
      final character = characterBloc.state.character;

      Item? currentlyEquipped;
      switch (widget.selectedSlot) {
        case SelectedSlot.weapon:
          currentlyEquipped = character.equippedWeapon;
          break;
        case SelectedSlot.helmet:
          currentlyEquipped = character.equippedHelmet;
          break;
        case SelectedSlot.chestplate:
          currentlyEquipped = character.equippedChestplate;
          break;
        case SelectedSlot.leggings:
          currentlyEquipped = character.equippedLeggings;
          break;
        case SelectedSlot.boots:
          currentlyEquipped = character.equippedBoots;
          break;
        case SelectedSlot.none:
          break;
      }

      if (currentlyEquipped != null) {
        List<Item?> availableItems = [];
        if (widget.selectedSlot == SelectedSlot.weapon) {
          availableItems.add(ItemRegistry.fist);
        } else {
          availableItems.add(null);
        }
        final allItems = inventoryBloc.state.inventory.items;
        for (final item in allItems) {
          if (item == null) continue;
          if (widget.selectedSlot == SelectedSlot.weapon && item.type == ItemType.weapon) {
            availableItems.add(item);
          } else if (item.type == ItemType.armor && item is Armor) {
            if (widget.selectedSlot == SelectedSlot.helmet && item.armorType == ArmorType.helmet) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.chestplate && item.armorType == ArmorType.chestplate) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.leggings && item.armorType == ArmorType.leggings) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.boots && item.armorType == ArmorType.boots) {
              availableItems.add(item);
            }
          }
        }
        if (!availableItems.any((i) => i?.id == currentlyEquipped!.id)) {
          availableItems.add(currentlyEquipped);
        }

        // Sort to match build method
        availableItems.sort((a, b) {
          if (a == null && b == null) return 0;
          if (a == null) return -1;
          if (b == null) return 1;
          if (a.id == 'fist') return -1;
          if (b.id == 'fist') return 1;
          return a.id.compareTo(b.id);
        });

        initialIndex = availableItems.indexWhere((i) => i?.id == currentlyEquipped!.id);
        if (initialIndex == -1) initialIndex = 0;
      }
    }

    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedSlot == SelectedSlot.none) {
      return const SizedBox();
    }

    final inventoryBloc = context.watch<InventoryBloc>();
    final characterBloc = context.watch<CharacterBloc>();
    final character = characterBloc.state.character;

    // Filter items based on selected slot
    List<Item?> availableItems = [];

    // The first option is always "EMPTY" or "fist" for weapons
    if (widget.selectedSlot == SelectedSlot.weapon) {
      availableItems.add(ItemRegistry.fist);
    } else {
      availableItems.add(null);
    }

    final allItems = inventoryBloc.state.inventory.items;
    for (final item in allItems) {
      if (item == null) continue;

      if (widget.selectedSlot == SelectedSlot.weapon && item.type == ItemType.weapon) {
        availableItems.add(item);
      } else if (item.type == ItemType.armor && item is Armor) {
        if (widget.selectedSlot == SelectedSlot.helmet && item.armorType == ArmorType.helmet) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.chestplate && item.armorType == ArmorType.chestplate) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.leggings && item.armorType == ArmorType.leggings) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.boots && item.armorType == ArmorType.boots) {
          availableItems.add(item);
        }
      }
    }

    Item? currentlyEquipped;
    switch (widget.selectedSlot) {
      case SelectedSlot.weapon:
        currentlyEquipped = character.equippedWeapon;
        break;
      case SelectedSlot.helmet:
        currentlyEquipped = character.equippedHelmet;
        break;
      case SelectedSlot.chestplate:
        currentlyEquipped = character.equippedChestplate;
        break;
      case SelectedSlot.leggings:
        currentlyEquipped = character.equippedLeggings;
        break;
      case SelectedSlot.boots:
        currentlyEquipped = character.equippedBoots;
        break;
      case SelectedSlot.none:
        break;
    }

    if (currentlyEquipped != null && !availableItems.any((i) => i?.id == currentlyEquipped?.id)) {
      availableItems.add(currentlyEquipped);
    }

    // Sort to maintain stable list order when equipping/unequipping
    availableItems.sort((a, b) {
      if (a == null && b == null) return 0;
      if (a == null) return -1;
      if (b == null) return 1;
      if (a.id == 'fist') return -1;
      if (b.id == 'fist') return 1;
      return a.id.compareTo(b.id);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return ItemPicker(
          controller: _controller,
          items: availableItems,
          height: constraints.maxHeight,
          emptyIconPath: _getIconForSlot(widget.selectedSlot),
          onSelectedItemChanged: (index) {
            final itemToEquip = availableItems[index];

            Item? equippedNow;
            switch (widget.selectedSlot) {
              case SelectedSlot.weapon:
                equippedNow = characterBloc.state.character.equippedWeapon;
                break;
              case SelectedSlot.helmet:
                equippedNow = characterBloc.state.character.equippedHelmet;
                break;
              case SelectedSlot.chestplate:
                equippedNow = characterBloc.state.character.equippedChestplate;
                break;
              case SelectedSlot.leggings:
                equippedNow = characterBloc.state.character.equippedLeggings;
                break;
              case SelectedSlot.boots:
                equippedNow = characterBloc.state.character.equippedBoots;
                break;
              case SelectedSlot.none:
                break;
            }

            if (equippedNow?.id == itemToEquip?.id) return;

            if (equippedNow != null && equippedNow.id != 'fist') {
              inventoryBloc.add(InventoryEvent$AddItem(item: equippedNow));
            }

            if (itemToEquip != null) {
              if (itemToEquip.id != 'fist') {
                inventoryBloc.add(InventoryEvent$RemoveItem(item: itemToEquip));
              }

              if (itemToEquip is Weapon) {
                characterBloc.add(CharacterEquipWeapon(itemToEquip));
              } else if (itemToEquip is Armor) {
                characterBloc.add(CharacterEquipArmor(itemToEquip));
              }
            } else {
              switch (widget.selectedSlot) {
                case SelectedSlot.weapon:
                  characterBloc.add(CharacterUnequipWeapon());
                  break;
                case SelectedSlot.helmet:
                  characterBloc.add(CharacterUnequipArmor(ArmorType.helmet));
                  break;
                case SelectedSlot.chestplate:
                  characterBloc.add(CharacterUnequipArmor(ArmorType.chestplate));
                  break;
                case SelectedSlot.leggings:
                  characterBloc.add(CharacterUnequipArmor(ArmorType.leggings));
                  break;
                case SelectedSlot.boots:
                  characterBloc.add(CharacterUnequipArmor(ArmorType.boots));
                  break;
                case SelectedSlot.none:
                  break;
              }
            }
          },
        );
      },
    );
  }

  String? _getIconForSlot(SelectedSlot slot) {
    switch (slot) {
      case SelectedSlot.weapon:
        return 'assets/icons/stock_equip/equip_weapon_icon.png';
      case SelectedSlot.helmet:
        return 'assets/icons/stock_equip/equip_helmet_icon.png';
      case SelectedSlot.chestplate:
        return 'assets/icons/stock_equip/equip_breastplate_icon.png';
      case SelectedSlot.leggings:
        return 'assets/icons/stock_equip/equip_leggings_icon.png';
      case SelectedSlot.boots:
        return 'assets/icons/stock_equip/equip_boots_icon.png';
      default:
        return null;
    }
  }
}
