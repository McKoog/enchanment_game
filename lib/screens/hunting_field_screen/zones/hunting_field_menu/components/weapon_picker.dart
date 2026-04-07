import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_slot.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/enemy_picker/components/horizontal_list_wheel_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeaponPicker extends StatelessWidget {
  const WeaponPicker({super.key, required this.controllerWeapon, required this.constraints});

  final FixedExtentScrollController controllerWeapon;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();
    List<Weapon> myWeapons = context.watch<InventoryBloc>().state.inventory.getAllMyWeapons(true);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: constraints.maxHeight / 5,
            //color: Colors.grey.shade800,
            child: HorizontalListWheelScrollView(
              controller: controllerWeapon,
              childCount: myWeapons.length,
              scrollDirection: Axis.horizontal,
              itemExtent: 150,
              onSelectedItemChanged: (index) {
                huntingFieldsBloc.add(HuntingFieldEvent$SelectWeapon(weapon: myWeapons[index]));
                // ref
                //     .read(currentSelectedWeaponHuntingField.notifier)
                //     .update((state) => myWeapons[index]);
              },
              builder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.all(4),
                    child: InventorySlot(
                      index: 1000,
                      item: myWeapons[index],
                      canBeDragged: false,
                      canBeDragTarget: false,
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
