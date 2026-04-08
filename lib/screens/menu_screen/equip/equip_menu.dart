import 'package:enchantment_game/screens/menu_screen/equip/equip_zone.dart';
import 'package:flutter/material.dart';

class EquipMenu extends StatelessWidget {
  const EquipMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;

      return EquipZone(height: height, width: width);
    });
  }
}
