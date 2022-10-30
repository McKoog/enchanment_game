import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';

class WeaponInfoField extends StatelessWidget {
  const WeaponInfoField({Key? key,required this.sideSize,required this.weapon}) : super(key: key);
  final double sideSize;
  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(weapon.enchantLevel >0 ?"${weapon.name} +${weapon.enchantLevel}":weapon.name, style: weaponNameDecoration),
          const SizedBox(height: 16,),
          Text("Damage: ${weapon.lowerDamage}-${weapon.higherDamage}",style: weaponInfoTextDecoration,),
        ],
      ),
    );
  }
}
