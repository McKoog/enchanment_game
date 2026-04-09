import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_slot.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/enemy_picker/components/horizontal_list_wheel_scroll_view.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ItemPicker extends StatelessWidget {
  const ItemPicker({
    super.key,
    required this.controller,
    required this.items,
    required this.onSelectedItemChanged,
    this.height = 100,
    this.emptyIconPath,
    this.onItemTap,
  });

  final FixedExtentScrollController controller;
  final List<Item?> items;
  final ValueChanged<int> onSelectedItemChanged;
  final double height;
  final String? emptyIconPath;
  final ValueChanged<Item>? onItemTap;

  @override
  Widget build(BuildContext context) {
    final double boxSize = height * 0.55;
    final double iconSize = boxSize * 0.6;
    // final double itemWidth = boxSize + 60;

    return Row(
      children: [
        InkWell(
          onTap: () {
            if (controller.hasClients && controller.selectedItem > 0) {
              controller.animateToItem(
                controller.selectedItem - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.accentYellow,
            size: 40,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: height,
            child: HorizontalListWheelScrollView(
              controller: controller,
              childCount: items.length,
              scrollDirection: Axis.horizontal,
              itemExtent: 150,
              onSelectedItemChanged: onSelectedItemChanged,
              builder: (BuildContext context, int index) {
                final item = items[index];

                if (item == null) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            color: AppColors.slotBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: Center(
                            child: emptyIconPath != null
                                ? Image.asset(
                                    emptyIconPath!,
                                    fit: BoxFit.contain,
                                    width: 160,
                                    height: 180,
                                    color: Colors.white54,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                    size: iconSize,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'EMPTY',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PT Sans',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onItemTap != null) {
                              onItemTap!(item);
                            }
                          },
                          child: SizedBox(
                            width: boxSize,
                            height: boxSize,
                            child: InventorySlot(
                              index: 1000 + index,
                              item: item,
                              canBeDragged: false,
                              canBeDragTarget: false,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item is Weapon
                              ? (item.enchantLevel > 0
                                  ? "${item.displayName} +${item.enchantLevel}"
                                  : item.displayName)
                              : (item is Armor
                                  ? (item.enchantLevel > 0
                                      ? "${item.displayName} +${item.enchantLevel}"
                                      : item.displayName)
                                  : ''),
                          style: AppTypography.titleLargeHighlight
                              .copyWith(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ));
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (controller.hasClients &&
                controller.selectedItem < items.length - 1) {
              controller.animateToItem(
                controller.selectedItem + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.accentYellow,
            size: 40,
          ),
        ),
      ],
    );
  }
}
