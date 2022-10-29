import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/base_main_zone_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/scroll_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/weapon_info_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainZone extends ConsumerWidget {
  const MainZone({Key? key, required this.height,required this.width}) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    Item? currScroll = ref.watch(currentScroll);
    Item? currWeapon = ref.watch(currentWeapon);
    bool showScroll = ref.watch(showScrollField);
    bool showWeapon = ref.watch(showWeaponInfoField);
    return SizedBox(
      height: height,
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: (showWeapon || showScroll)
            ?BaseMainZoneField(
              sideSize: height,
              backgroundItem: currScroll ?? currWeapon,
              child: currScroll != null ? ScrollField(sideSize: height):WeaponInfoField(sideSize: height, weapon: currWeapon! as Weapon),
        )
            :const SizedBox()
      ),
    );
  }
}