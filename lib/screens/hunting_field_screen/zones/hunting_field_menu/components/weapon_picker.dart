import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/own_packages/HorizonalListWheelScrollView.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeaponPicker extends ConsumerWidget {
  const WeaponPicker({Key? key,required this.controllerWeapon,required this.constraints}) : super(key: key);

  final FixedExtentScrollController controllerWeapon;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    var inv = ref.watch(inventory);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);

    return Row(
      children: [
        InkWell(
            onTap: () {
              if (controllerWeapon.selectedItem > 0) {
                controllerWeapon.animateToItem(
                    controllerWeapon.selectedItem - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 80,
              color: Colors.yellow,
            )),
        Expanded(
          child: SizedBox(
            height: constraints.maxHeight / 4,
            //color: Colors.grey.shade800,
            child: HorizontalListWheelScrollView(
              controller: controllerWeapon,
              childCount: myWeapons.length,
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              onSelectedItemChanged: (index) {
                ref
                    .read(currentSelectedWeaponHuntingField.notifier)
                    .update((state) => myWeapons[index]);
              },
              builder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.all(16),
                    child: InventorySlot(
                        index: 1000, item: myWeapons[index]));
              },
            ),
          ),
        ),
        InkWell(
            onTap: () {
              if (controllerWeapon.selectedItem <
                  myWeapons.length - 1) {
                controllerWeapon.animateToItem(
                    controllerWeapon.selectedItem + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            },
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 80,
              color: Colors.yellow,
            )),
      ],
    );
  }
}
