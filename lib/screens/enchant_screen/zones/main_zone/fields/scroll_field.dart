import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_enchant_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends ConsumerWidget {
  const ScrollField({Key? key,required this.sideSize,required this.scroll}) : super(key: key);
  final double sideSize;
  final Scroll scroll;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    Weapon? weaponInSlot = ref.read(scrollEnchantSlotItem);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height:ref.watch(scrollEnchantSlotItem) != null ?sideSize/14 :0,child: AutoSizeText(weaponInSlot?.name ?? "",style: weaponNameDecoration,)),
          SizedBox(height:ref.watch(scrollEnchantSlotItem) == null ?null :0,child: AutoSizeText(scroll.name,style: scrollNameDecoration,textAlign: TextAlign.center,maxLines: 1,)),
          SizedBox(height:ref.watch(scrollEnchantSlotItem) == null ?null :0,child: AutoSizeText("Put your weapon in the slot",style: scrollHintDecoration, maxLines: 1,)),
          Padding(
            padding: EdgeInsets.only(bottom: ref.watch(scrollEnchantSlotItem) != null ?8.0 :0),
            child: ScrollEnchantSlot(sideSize: ref.watch(scrollEnchantSlotItem) == null ?(sideSize-50)/4 : (sideSize-50)/1.6,),
          ),
          SizedBox(height:ref.watch(scrollEnchantSlotItem) == null ?null :0,child: AutoSizeText(scroll.description, style: scrollInfoTextDecoration,textAlign: TextAlign.center,maxLines: 2,)),
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
                      textStyle: scrollBottonsTextDecoration,
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
                    textStyle: scrollBottonsTextDecoration,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      backgroundColor: const Color.fromRGBO(130, 130, 130, 1)
                  ),
                  child: const AutoSizeText("Enchant",maxLines: 1,),),
              ),
            ],
          )
        ],
      ),
    );
  }
}