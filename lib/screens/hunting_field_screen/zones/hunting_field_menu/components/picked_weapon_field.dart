import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickedWeaponField extends StatelessWidget {
  const PickedWeaponField({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<InventoryBloc>();
    Weapon? selectedWeapon =
        context.watch<HuntingFieldsBloc>().state.selectedWeapon;

    return SizedBox(
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
    );
  }
}
