import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/hunting_field_menu.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/moster_page/monster_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HuntingFieldScreen extends ConsumerWidget {
  const HuntingFieldScreen({Key? key, required this.width}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print(ref.read(currentSelectedWeaponHuntingField));
      print(ref.read(currentSelectedMonsterHuntingField));
      return ref.watch(showHuntMonsterPage)
          ? MonsterPage(
              width: width,
              monster: ref.read(currentSelectedMonsterHuntingField)!,
              weapon: ref.watch(currentSelectedWeaponHuntingField)!,
            )
          : HuntingFieldsMenu(constraints: constraints, width: width);
    }));
  }
}
