import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:flutter/material.dart';

class ArmorInfoField extends StatelessWidget {
  const ArmorInfoField(
      {super.key, required this.sideSize, required this.armor});

  final double sideSize;
  final Armor armor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              armor.enchantLevel > 0
                  ? "${armor.name} +${armor.enchantLevel}"
                  : armor.name,
              style: weaponNameDecoration),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Defense: ${armor.defense}",
            style: weaponInfoTextDecoration,
          ),
        ],
      ),
    );
  }
}
