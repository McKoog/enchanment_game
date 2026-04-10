import 'package:enchantment_game/blocs/enchant_bloc/enchant_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/blocs/item_info_bloc/item_info_state.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/components/enchant_stats_effects_view.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/armor_info_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/info_background.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/scroll_field.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/fields/weapon_info_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantZone extends StatelessWidget {
  const EnchantZone({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemInfoBloc, ItemInfoState>(
        bloc: context.read<ItemInfoBloc>(),
        builder: (context, state) {
          return SizedBox(
            height: height,
            width: width,
            child: state is ItemInfoState$Showed
                ? Align(
                    alignment: Alignment.center,
                    child: Padding(
                      key: ValueKey(state.viewToken),
                      padding: const EdgeInsets.all(8.0),
                      child: InfoBackground(
                        sideSize: height,
                        backgroundItem: state.item,
                        child: state.item is Scroll
                            ? BlocProvider(
                                create: (context) => EnchantBloc(),
                                child: ScrollField(
                                    sideSize: height,
                                    scroll: state.item as Scroll,
                                    inventoryIndex: state.inventoryIndex))
                            : state.item is Weapon
                                ? WeaponInfoField(
                                    sideSize: height,
                                    weapon: state.item as Weapon)
                                : ArmorInfoField(
                                    sideSize: height,
                                    armor: state.item as Armor),
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: EnchantStatsEffectsView(),
                  ),
          );
        });
  }
}
