import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/monster_picker.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/picked_monster_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/picked_weapon_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/weapon_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HuntingFieldsMenu extends ConsumerStatefulWidget {
  const HuntingFieldsMenu(
      {Key? key, required this.constraints, required this.width})
      : super(key: key);
  final BoxConstraints constraints;
  final double width;

  @override
  ConsumerState<HuntingFieldsMenu> createState() => _HuntingFieldsMenuState();
}

class _HuntingFieldsMenuState extends ConsumerState<HuntingFieldsMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FixedExtentScrollController controllerWeapon;
  late final FixedExtentScrollController controllerMonster;

  @override
  void initState() {
    var inv = ref.read(inventory);
    List<Weapon?> myWeapons = inv.getAllMyWeapons(true);
    controllerWeapon =
        FixedExtentScrollController(initialItem: myWeapons.length > 2 ? 1 : 0);
    controllerMonster = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  Widget title(String text){
    return Text(
      text,
      style: huntFieldNameTextDecoration,
    );
  }

  Widget descriptionText(String text){
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
            descriptionText("At first, pick avaliable weapon to fight monsters with..."),
            WeaponPicker(controllerWeapon: controllerWeapon,constraints: widget.constraints,),
            const PickedWeaponField(),
            descriptionText("Then,select your enemy..."),
            MonsterPicker(controllerMonster: controllerMonster, constraints: widget.constraints),
            const PickedMonsterField(),
          ],
        ),
      ),
    );
  }
}