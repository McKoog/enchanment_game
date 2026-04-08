import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:flutter/material.dart';

class EquipMenu extends StatelessWidget {
  const EquipMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Text(
          'Equip menu will be added soon...',
          style: huntFieldHeaderTextDecoration,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
