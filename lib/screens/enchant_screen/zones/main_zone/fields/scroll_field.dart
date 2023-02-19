import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/game_stock_items/game_stock%20items.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_button.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends ConsumerWidget {
  const ScrollField({Key? key, required this.sideSize, required this.scroll})
      : super(key: key);
  final double sideSize;
  final Scroll scroll;

  bool checkIsEnchantSuccess(){
    int rand = Random().nextInt(101);
    if(rand <= 75){
      return true;
    }
    else{
      return false;
    }
  }

  Weapon enchantWeapon(Weapon weapon){
    weapon.enchantLevel += 1;
    if(weapon.weaponType == WeaponType.sword){
      weapon.lowerDamage += 1;
      weapon.higherDamage += 2;
    }
    else if(weapon.weaponType == WeaponType.bow){
      weapon.higherDamage += 3;
    }
    else if(weapon.weaponType == WeaponType.dagger){
      weapon.lowerDamage += 1;
      weapon.higherDamage += 1;
    }
    return weapon;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Weapon? weaponInSlot = ref.read(scrollEnchantSlotItem);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              height: ref.watch(scrollEnchantSlotItem) != null ? sideSize / 14 : 0,
              child: AutoSizeText(
                weaponInSlot == null ?"":weaponInSlot.enchantLevel >0 ?"${weaponInSlot.name} +${weaponInSlot.enchantLevel}":weaponInSlot.name, style: weaponNameDecoration,
              )),
          SizedBox(
              height: ref.watch(scrollEnchantSlotItem) == null && ref.watch(currentEnchantSuccess) == null ? null : 0,
              child: AutoSizeText(
                scroll.name,
                style: scrollNameDecoration,
                textAlign: TextAlign.center,
                maxLines: 1,
              )),
          SizedBox(
              height: ref.watch(scrollEnchantSlotItem) == null && ref.watch(currentEnchantSuccess) == null ? null : 0,
              child: AutoSizeText(
                "Put your weapon in the slot",
                style: scrollHintDecoration,
                maxLines: 1,
              )),
          Padding(
            padding: EdgeInsets.only(
                bottom: ref.watch(scrollEnchantSlotItem) != null ? 8.0 : 0),
            child: ScrollEnchantSlot(
              sideSize: ref.watch(scrollEnchantSlotItem) == null
                  ? (sideSize - 50) / 4
                  : ref.watch(startProgressBarAnimation)
                      ? (sideSize - 50) / 4
                      : (sideSize - 50) / 1.6,
            ),
          ),
          SizedBox(
              height: ref.watch(scrollEnchantSlotItem) == null && ref.watch(currentEnchantSuccess) == null ? null : 0,
              child: AutoSizeText(
                scroll.description,
                style: scrollInfoTextDecoration,
                textAlign: TextAlign.center,
                maxLines: 2,
              )),

          ref.watch(showScrollProgressBar)
              ? EnchantProgressBar(
                  parentSize: sideSize,
                )
              : ref.watch(finishedProgressBarAnimation)
                  ? SizedBox(
                      height: ref.watch(currentEnchantSuccess) != null
                        ? null
                        : null,
                    child: Text(
                    (ref.read(currentEnchantSuccess) == null)
                      ?"Wait"
                    :ref.read(currentEnchantSuccess)!
                      ?"Success"
                      :"Failed",
                    style: (ref.read(currentEnchantSuccess) != null) && ref.read(currentEnchantSuccess)!
                      ?enchantSuccessTextDecoration
                      :enchantFailTextDecoration)
          )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScrollFieldButton(
                            parentSize: sideSize,
                            caption: "Cancel",
                            onPressed: () {
                              ref
                                  .read(showWeaponInfoField.notifier)
                                  .update((state) => false);
                              ref
                                  .read(currentWeapon.notifier)
                                  .update((state) => null);
                              ref
                                  .read(showScrollField.notifier)
                                  .update((state) => !state);
                              if (ref.read(showScrollField) == false) {
                                ref
                                    .read(scrollEnchantSlotItem.notifier)
                                    .update((state) => null);
                              }
                            }),
                        ScrollFieldButton(
                            parentSize: sideSize,
                            caption: "Enchant",
                            onPressed: () {
                              if(ref.read(scrollEnchantSlotItem) != null) {
                                ref
                                    .read(showScrollProgressBar.notifier)
                                    .update((state) => true);
                                ref
                                    .read(startProgressBarAnimation.notifier)
                                    .update((state) => true);

                                Future.delayed(const Duration(milliseconds: 1200),(){
                                  Weapon enchantingWeapon = ref.read(inventory.notifier).state.items.firstWhere((element) => element == ref.read(scrollEnchantSlotItem)) as Weapon;
                                  if(checkIsEnchantSuccess()){
                                    ref.read(currentEnchantSuccess.notifier).update((state) => true);
                                    enchantWeapon(enchantingWeapon);
                                    //enchantingWeapon.enchantLevel += 1;
                                    // enchantingWeapon.lowerDamage += 1;
                                    // enchantingWeapon.higherDamage += 2;
                                    if(ref.read(currentSelectedWeaponHuntingField) != null && ref.read(currentSelectedWeaponHuntingField)!.id == enchantingWeapon.id) {
                                      Weapon weapon = Weapon.copyWith(enchantingWeapon);
                                      ref.read(currentSelectedWeaponHuntingField.notifier).update((state) => weapon);
                                    }
                                    ref.read(inventory.notifier).update((state) => ref.read(inventory).removeItem(scroll));
                                  }
                                  else{
                                    if(ref.read(currentSelectedWeaponHuntingField) != null && ref.read(currentSelectedWeaponHuntingField)!.id == enchantingWeapon.id) {
                                      ref.read(currentSelectedWeaponHuntingField.notifier).update((state) => stockFist);
                                    }
                                    ref.read(currentEnchantSuccess.notifier).update((state) => false);
                                    /*enchantingWeapon.enchantLevel = 0;
                                    enchantingWeapon.lowerDamage = 2;
                                    enchantingWeapon.higherDamage = 3;*/
                                    ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
                                    ref.read(inventory.notifier).update((state) => ref.read(inventory).removeItem(enchantingWeapon));
                                    ref.read(inventory.notifier).update((state) => ref.read(inventory).removeItem(scroll));
                                  }
                                });
                              }
                            }),
                      ],
                    )
        ],
      ),
    );
  }
}
