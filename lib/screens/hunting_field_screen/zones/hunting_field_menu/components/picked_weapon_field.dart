import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickedWeaponField extends ConsumerWidget {
  const PickedWeaponField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var inv = ref.watch(inventory);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);
    Weapon? selectedWeapon = ref.watch(currentSelectedWeaponHuntingField);
    selectedWeapon ??
        SchedulerBinding.instance.addPostFrameCallback((_) => ref
            .read(currentSelectedWeaponHuntingField.notifier)
            .update((state) => myWeapons.length > 2
            ? myWeapons[1]
            : myWeapons[
        0]));

    return selectedWeapon != null
        ? SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: huntBeginButtonDecoration,
                child: Text(
                  selectedWeapon.enchantLevel > 0
                      ? "${selectedWeapon.name} +${selectedWeapon.enchantLevel}"
                      : selectedWeapon.name,
                  style: huntFieldSelectedWeaponTextDecoration,
                ),
              )),
        ],
      ),
    )
        : SizedBox(
        height: 80, width: MediaQuery.of(context).size.width - 60);
  }
}
