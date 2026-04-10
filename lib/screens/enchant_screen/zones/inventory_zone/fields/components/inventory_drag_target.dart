import 'dart:async';

import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/enchant_bloc/enchant_event.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_event.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryDragTarget extends StatefulWidget {
  const InventoryDragTarget(
      {super.key,
      required this.inventoryIndex,
      this.child = const SizedBox.shrink(),
      this.canBeDragTarget = true});

  final int inventoryIndex;
  final Widget child;
  final bool canBeDragTarget;

  @override
  State<InventoryDragTarget> createState() => _InventoryDragTargetState();
}

class _InventoryDragTargetState extends State<InventoryDragTarget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _activeEntry;

  @override
  void dispose() {
    _activeEntry?.remove();
    _activeEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canBeDragTarget) {
      return widget.child;
    }
    final draggableBloc = context.read<DraggableItemsBloc>();
    final inventoryBloc = context.read<InventoryBloc>();

    return CompositedTransformTarget(
      link: _layerLink,
      child: DragTarget<Item>(onAcceptWithDetails: (details) async {
        final dragState = draggableBloc.state;
        if (dragState is DraggableItemsState$Dragged) {
          final fromIndex = dragState.itemInventoryIndex;
          if (fromIndex == widget.inventoryIndex) return;

          final invItems = inventoryBloc.state.inventory.items;
          final fromItem = invItems[fromIndex];
          final toItem = invItems[widget.inventoryIndex];
          final toScroll = toItem is Scroll ? toItem : null;

          if (fromItem is Scroll && fromItem.quantity > 1) {
            final canMoveToEmpty = toItem == null;
            final canMerge =
                toScroll != null && _isSameScrollType(fromItem, toScroll);

            if (canMoveToEmpty || canMerge) {
              final maxTransfer = canMerge
                  ? _minInt(
                      fromItem.quantity,
                      Scroll.maxStackSize - toScroll.quantity,
                    )
                  : fromItem.quantity;

              if (maxTransfer <= 0) return;

              if (maxTransfer == 1) {
                inventoryBloc.add(InventoryEvent$SplitScrollStack(
                    fromIndex: fromIndex,
                    toIndex: widget.inventoryIndex,
                    quantity: 1));
                return;
              }

              final chosen =
                  await _showQuantityPopover(context, maxQuantity: maxTransfer);
              if (chosen == null) return;

              inventoryBloc.add(InventoryEvent$SplitScrollStack(
                  fromIndex: fromIndex,
                  toIndex: widget.inventoryIndex,
                  quantity: chosen));
              return;
            }
          }

          inventoryBloc.add(InventoryEvent$SwapItems(
              fromIndex: fromIndex, toIndex: widget.inventoryIndex));
        } else {
          final draggedItem = details.data;
          final invItems = inventoryBloc.state.inventory.items;
          final toItem = invItems[widget.inventoryIndex];

          final characterBloc = context.read<CharacterBloc>();
          final enchantBloc = context.read<EnchantBloc>();

          bool isFromEnchantSlot =
              enchantBloc.state.insertedItem == draggedItem;

          if (toItem == null) {
            inventoryBloc.add(InventoryEvent$AddItemAt(
                item: draggedItem, index: widget.inventoryIndex));

            if (isFromEnchantSlot) {
              enchantBloc.add(EnchantEvent$ExtractItem());
            } else {
              if (draggedItem is Weapon) {
                characterBloc.add(CharacterUnequipWeapon());
              } else if (draggedItem is Armor) {
                characterBloc.add(CharacterUnequipArmor(draggedItem.armorType));
              }
            }
          } else {
            // Drop on occupied slot
            bool isSameArmorType = true;
            if (draggedItem is Armor && toItem is Armor) {
              isSameArmorType = draggedItem.armorType == toItem.armorType;
            }

            if (toItem.type == draggedItem.type && isSameArmorType) {
              if (isFromEnchantSlot) {
                enchantBloc.add(EnchantEvent$ExtractItem());
                enchantBloc.add(EnchantEvent$InsertItem(item: toItem));
              } else {
                if (draggedItem is Weapon) {
                  characterBloc.add(CharacterEquipWeapon(toItem as Weapon));
                } else if (draggedItem is Armor) {
                  characterBloc
                      .add(CharacterUnequipArmor(draggedItem.armorType));
                  characterBloc.add(CharacterEquipArmor(toItem as Armor));
                }
              }
              inventoryBloc.add(InventoryEvent$RemoveItem(item: toItem));
              inventoryBloc.add(InventoryEvent$AddItemAt(
                  item: draggedItem, index: widget.inventoryIndex));
            } else {
              // Different type, so just put dragged in this slot, and the old item in the first empty slot.
              inventoryBloc.add(InventoryEvent$RemoveItem(item: toItem));
              inventoryBloc.add(InventoryEvent$AddItemAt(
                  item: draggedItem, index: widget.inventoryIndex));
              inventoryBloc.add(InventoryEvent$AddItem(item: toItem));
              if (isFromEnchantSlot) {
                enchantBloc.add(EnchantEvent$ExtractItem());
              } else {
                if (draggedItem is Weapon) {
                  characterBloc.add(CharacterUnequipWeapon());
                } else if (draggedItem is Armor) {
                  characterBloc
                      .add(CharacterUnequipArmor(draggedItem.armorType));
                }
              }
            }
          }
        }
      }, builder: (BuildContext context, List<Item?> candidateData,
          List<dynamic> rejectedData) {
        return widget.child;
      }),
    );
  }

  static bool _isSameScrollType(Scroll a, Scroll b) {
    return a.name == b.name &&
        a.image == b.image &&
        a.description == b.description;
  }

  static int _minInt(int a, int b) => a < b ? a : b;

  Future<int?> _showQuantityPopover(BuildContext context,
      {required int maxQuantity}) async {
    final overlay = Overlay.of(context, rootOverlay: true);

    _activeEntry?.remove();
    _activeEntry = null;

    final completer = Completer<int?>();
    var selected = maxQuantity;

    late final OverlayEntry entry;
    void close([int? result]) {
      if (completer.isCompleted) return;
      entry.remove();
      if (_activeEntry == entry) {
        _activeEntry = null;
      }
      completer.complete(result);
    }

    entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => close(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
              offset: const Offset(0, -6),
              child: Material(
                color: AppColors.transparent,
                child: GestureDetector(
                  onTap: () {},
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      width: 166,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.overlayVeryDark,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.panelBorder, width: 1),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$selected/$maxQuantity',
                                style: AppTypography.attributeLabel
                                    .copyWith(color: AppColors.white),
                              ),
                              SizedBox(
                                height: 22,
                                width: 120,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 10),
                                    activeTrackColor: AppColors.white,
                                    inactiveTrackColor:
                                        AppColors.slotBackground,
                                    thumbColor: AppColors.white,
                                  ),
                                  child: Slider(
                                    value: selected.toDouble(),
                                    min: 1,
                                    max: maxQuantity.toDouble(),
                                    divisions: maxQuantity > 1
                                        ? maxQuantity - 1
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value.round();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => close(selected),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.check,
                                  size: 24, color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
    return completer.future;
  }
}
