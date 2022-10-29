import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/base_main_zone_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends StatelessWidget {
  const ScrollField({Key? key,required this.sideSize,required this.scroll}) : super(key: key);
  final double sideSize;
  final Scroll scroll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(scroll.name,style: scrollNameDecoration,textAlign: TextAlign.center,),
          ScrollEnchantSlot(sideSize: (sideSize-100)/4,),
          Text(scroll.description, style: scrollInfoTextDecoration,textAlign: TextAlign.center,),
          ElevatedButton(
            onPressed: (){},
            style: OutlinedButton.styleFrom(
              textStyle: scrollInfoTextDecoration,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                backgroundColor: const Color.fromRGBO(130, 130, 130, 1)
            ),
            child: const Text("Enchant"),)
        ],
      ),
    );
  }
}