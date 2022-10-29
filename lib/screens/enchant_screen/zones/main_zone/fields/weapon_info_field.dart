import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/base_main_zone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeaponInfoField extends StatelessWidget {
  const WeaponInfoField({Key? key,required this.sideSize}) : super(key: key);
  final double sideSize;
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Text("HELLO"),
    );
  }
}
