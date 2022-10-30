import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ScrollEnchantSlot extends ConsumerWidget {
  const ScrollEnchantSlot({Key? key,required this.sideSize}) : super(key: key);
  final double sideSize;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return DragTarget<Item>(
      onAccept: (value){
        if(value.type == ItemType.weapon) {
          ref.read(scrollEnchantSlotItem.notifier).update((state) => value as Weapon);
        }
      },
      builder: (BuildContext context, List<Item?> candidateData, List<dynamic> rejectedData) {
        return AnimatedContainer(
          padding: const EdgeInsets.all(4),
            decoration: scrollEnchantSlotDecoration,
            height: sideSize,
            width: sideSize,
            duration: const Duration(milliseconds: 500),
            child: ref.watch(scrollEnchantSlotItem) != null
                ?SvgPicture.asset(ref.read(scrollEnchantSlotItem)!.image)
                :null
        );
      },
    );
  }
}