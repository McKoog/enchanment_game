import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/base_main_zone_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends ConsumerWidget {
  const ScrollField({Key? key,required this.sideSize,required this.scroll}) : super(key: key);
  final double sideSize;
  final Scroll scroll;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AutoSizeText(scroll.name,style: scrollNameDecoration,textAlign: TextAlign.center,maxLines: 1,),
          ScrollEnchantSlot(sideSize: (sideSize-50)/4,),
          AutoSizeText(scroll.description, style: scrollInfoTextDecoration,textAlign: TextAlign.center,maxLines: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: sideSize/10,
                width: sideSize/3,
                child: ElevatedButton(
                  onPressed: (){
                    ref.read(showWeaponInfoField.notifier).update((state) => false);
                    ref.read(currentWeapon.notifier).update((state) => null);
                    ref.read(showScrollField.notifier).update((state) => !state);
                    if(ref.read(showScrollField) == false)ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
                  },
                  style: OutlinedButton.styleFrom(
                      textStyle: scrollInfoTextDecoration,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      backgroundColor: const Color.fromRGBO(130, 130, 130, 1)
                  ),
                  child: const AutoSizeText("Cancel"),),
              ),
              SizedBox(
                height: sideSize/10,
                width: sideSize/3,
                child: ElevatedButton(
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(
                    textStyle: scrollInfoTextDecoration,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      backgroundColor: const Color.fromRGBO(130, 130, 130, 1)
                  ),
                  child: const AutoSizeText("Enchant"),),
              ),
            ],
          )
        ],
      ),
    );
  }
}