import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseMainZoneField extends ConsumerWidget {
  const BaseMainZoneField({Key? key,required this.sideSize,this.backgroundItem,required this.child}) : super(key: key);
  final double sideSize;
  final Widget child;
  final Item? backgroundItem;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
        decoration: enchantFieldDecoration,
        height:sideSize-24,
        width: sideSize-24,
        child:backgroundItem != null
                ?Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                        Opacity(opacity:0.1,child: InventorySlot(index: 0,item: backgroundItem,)),
                        child
                    ],
                )
                :child
    );
  }
}