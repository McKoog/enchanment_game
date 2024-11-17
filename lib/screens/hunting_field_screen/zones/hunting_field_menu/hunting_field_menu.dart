import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/monster_picker.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/picked_monster_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/picked_weapon_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/weapon_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldsMenu extends StatefulWidget {
  const HuntingFieldsMenu(
      {super.key, required this.constraints, required this.width});

  final BoxConstraints constraints;
  final double width;

  @override
  State<HuntingFieldsMenu> createState() => _HuntingFieldsMenuState();
}

class _HuntingFieldsMenuState extends State<HuntingFieldsMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FixedExtentScrollController controllerWeapon;
  late final FixedExtentScrollController controllerMonster;

  @override
  void initState() {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();
    var inventory = context.read<InventoryBloc>().state.inventory;
    List<Weapon?> myWeapons = inventory.getAllMyWeapons(true);
    int currSelectedWeaponIndex =
        myWeapons.indexOf(huntingFieldsBloc.state.selectedWeapon);
    controllerWeapon =
        FixedExtentScrollController(initialItem: currSelectedWeaponIndex);

    controllerMonster = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  Widget title(String text) {
    return Text(
      text,
      style: huntFieldNameTextDecoration,
    );
  }

  Widget descriptionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: huntFieldDescriptionTextDecoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: SizedBox(
        height: widget.constraints.maxHeight,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            title("HuntingField"),
            descriptionText(
                "At first, pick avaliable weapon to fight monsters with..."),
            WeaponPicker(
              controllerWeapon: controllerWeapon,
              constraints: widget.constraints,
            ),
            const PickedWeaponField(),
            descriptionText("Then,select your enemy..."),
            MonsterPicker(
                controllerMonster: controllerMonster,
                constraints: widget.constraints),
            const PickedMonsterField(),
          ],
        ),
      ),
    );
  }
}
