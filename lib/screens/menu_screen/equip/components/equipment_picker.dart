import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/armor_info_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/weapon_info_field.dart';
import 'package:enchantment_game/screens/menu_screen/equip/components/item_picker.dart';
import 'package:enchantment_game/screens/menu_screen/equip/equip_zone.dart';
import 'package:enchantment_game/theme/app_decorations.dart';
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
  OverlayEntry? _overlayEntry;

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
          if (widget.selectedSlot == SelectedSlot.weapon &&
              item.type == ItemType.weapon) {
            availableItems.add(item);
          } else if (item.type == ItemType.armor && item is Armor) {
            if (widget.selectedSlot == SelectedSlot.helmet &&
                item.armorType == ArmorType.helmet) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.chestplate &&
                item.armorType == ArmorType.chestplate) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.leggings &&
                item.armorType == ArmorType.leggings) {
              availableItems.add(item);
            } else if (widget.selectedSlot == SelectedSlot.boots &&
                item.armorType == ArmorType.boots) {
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
          if (a.id == 'fist' || a.id == 'template') return -1;
          if (b.id == 'fist' || b.id == 'template') return 1;
          return a.id.compareTo(b.id);
        });

        initialIndex =
            availableItems.indexWhere((i) => i?.id == currentlyEquipped!.id);
        if (initialIndex == -1) initialIndex = 0;
      }
    }

    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _hideItemInfoOverlay();
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

    // The first option is always "EMPTY"
    availableItems.add(null);

    final allItems = inventoryBloc.state.inventory.items;
    for (final item in allItems) {
      if (item == null) continue;

      if (widget.selectedSlot == SelectedSlot.weapon &&
          item.type == ItemType.weapon) {
        availableItems.add(item);
      } else if (item.type == ItemType.armor && item is Armor) {
        if (widget.selectedSlot == SelectedSlot.helmet &&
            item.armorType == ArmorType.helmet) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.chestplate &&
            item.armorType == ArmorType.chestplate) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.leggings &&
            item.armorType == ArmorType.leggings) {
          availableItems.add(item);
        } else if (widget.selectedSlot == SelectedSlot.boots &&
            item.armorType == ArmorType.boots) {
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

    if (currentlyEquipped != null &&
        !availableItems.any((i) => i?.id == currentlyEquipped?.id)) {
      availableItems.add(currentlyEquipped);
    }

    // Sort to maintain stable list order when equipping/unequipping
    availableItems.sort((a, b) {
      if (a == null && b == null) return 0;
      if (a == null) return -1;
      if (b == null) return 1;
      if (a.id == 'fist' || a.id == 'template') return -1;
      if (b.id == 'fist' || b.id == 'template') return 1;
      return a.id.compareTo(b.id);
    });

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ItemPicker(
              controller: _controller,
              items: availableItems,
              height: constraints.maxHeight,
              emptyIconPath: _getIconForSlot(widget.selectedSlot),
              onItemTap: (item) {
                _showItemInfoOverlay(context, item);
              },
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
                    equippedNow =
                        characterBloc.state.character.equippedChestplate;
                    break;
                  case SelectedSlot.leggings:
                    equippedNow =
                        characterBloc.state.character.equippedLeggings;
                    break;
                  case SelectedSlot.boots:
                    equippedNow = characterBloc.state.character.equippedBoots;
                    break;
                  case SelectedSlot.none:
                    break;
                }

                if (equippedNow?.id == itemToEquip?.id) return;

                if (equippedNow != null &&
                    equippedNow.id != 'fist' &&
                    equippedNow.id != 'template') {
                  inventoryBloc.add(InventoryEvent$AddItem(item: equippedNow));
                }

                if (itemToEquip != null) {
                  if (itemToEquip.id != 'fist' &&
                      itemToEquip.id != 'template') {
                    inventoryBloc
                        .add(InventoryEvent$RemoveItem(item: itemToEquip));
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
                      characterBloc
                          .add(CharacterUnequipArmor(ArmorType.helmet));
                      break;
                    case SelectedSlot.chestplate:
                      characterBloc
                          .add(CharacterUnequipArmor(ArmorType.chestplate));
                      break;
                    case SelectedSlot.leggings:
                      characterBloc
                          .add(CharacterUnequipArmor(ArmorType.leggings));
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
        ),
      ],
    );
  }

  void _showItemInfoOverlay(BuildContext context, Item item) {
    _hideItemInfoOverlay();

    final RenderBox pickerBox = context.findRenderObject() as RenderBox;
    final pickerOffset = pickerBox.localToGlobal(Offset.zero);

    final equipZoneState = context.findAncestorStateOfType<State<EquipZone>>();
    RenderBox? equipZoneBox;
    Offset equipZoneOffset = Offset.zero;
    Size equipZoneSize = MediaQuery.of(context).size;

    if (equipZoneState != null) {
      equipZoneBox = equipZoneState.context.findRenderObject() as RenderBox?;
      if (equipZoneBox != null) {
        equipZoneOffset = equipZoneBox.localToGlobal(Offset.zero);
        equipZoneSize = equipZoneBox.size;
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideItemInfoOverlay,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: equipZoneOffset.dx + 8,
              right: MediaQuery.of(context).size.width -
                  (equipZoneOffset.dx + equipZoneSize.width) +
                  8,
              top: equipZoneOffset.dy + 8,
              bottom: MediaQuery.of(context).size.height - pickerOffset.dy + 8,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: AppDecorations.panel,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Opacity(
                              opacity: 0.1,
                              child:
                                  Image.asset(item.image, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        item is Weapon
                            ? WeaponInfoField(sideSize: 400, weapon: item)
                            : item is Armor
                                ? ArmorInfoField(sideSize: 400, armor: item)
                                : const SizedBox(),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _hideItemInfoOverlay,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideItemInfoOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
