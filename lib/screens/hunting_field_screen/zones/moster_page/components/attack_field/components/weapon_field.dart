import 'package:enchantment_game/decorations/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeaponField extends StatelessWidget {
  const WeaponField({super.key, required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(50),
        padding: const EdgeInsets.all(27),
        decoration: weapon.enchantLevel < 1
            ? attackFieldDecoration
            : BoxDecoration(
                color: const Color.fromRGBO(85, 85, 85, 1),
                border: Border.fromBorderSide(BorderSide(
                    color: weapon.enchantLevel <= 15
                        ? const Color.fromRGBO(130, 130, 130, 1)
                        : weapon.enchantLevel <= 20
                            ? enchantedWeaponsGlowColors[weapon.enchantLevel]
                                .withOpacity(0.6)
                            : const Color.fromRGBO(130, 130, 130, 1),
                    width: 2)),
                shape: BoxShape.circle,
                boxShadow: weapon.enchantLevel == 0
                    ? null
                    : weapon.enchantLevel > 20
                        ? [
                            BoxShadow(
                                color: enchantedWeaponsGlowColors[21],
                                blurRadius: 30,
                                spreadRadius: 15)
                          ]
                        : [
                            BoxShadow(
                                color: enchantedWeaponsGlowColors[
                                    weapon.enchantLevel],
                                blurRadius: 30,
                                spreadRadius: 15)
                          ]),
        child: weapon.isSvgAsset
            ? SvgPicture.asset(
                weapon.image,
                fit: BoxFit.fitHeight,
              )
            : Image.asset(
                weapon.image,
                //fit: BoxFit.scaleDown,
              ));
  }
}
