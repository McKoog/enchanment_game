import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/gold_item.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class RecentLootList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  final List<Item> dropHistory;

  const RecentLootList({
    super.key,
    required this.listKey,
    required this.dropHistory,
  });

  String _getItemName(Item item) {
    if (item is GoldItem) return '${item.amount} Gold';
    if (item is Weapon) {
      return item.enchantLevel > 0 ? "${item.displayName} +${item.enchantLevel}" : item.displayName;
    }
    if (item is Armor) {
      return item.enchantLevel > 0 ? "${item.displayName} +${item.enchantLevel}" : item.displayName;
    }
    if (item is Scroll) return item.name;
    return 'Unknown Item';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Recent Loot:',
          style: AppTypography.bodySmallHighlight,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            color: AppColors.overlayMedium,
            child: AnimatedList(
              key: listKey,
              initialItemCount: dropHistory.length,
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 100),
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          dropHistory[index].image,
                          width: 40,
                          height: 40,
                          gaplessPlayback: true,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _getItemName(dropHistory[index]),
                          style: AppTypography.bodySmallPrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
