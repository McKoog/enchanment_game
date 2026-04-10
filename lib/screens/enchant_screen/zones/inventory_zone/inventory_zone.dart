import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/inventory_field.dart';
import 'package:flutter/material.dart';

class InventoryZone extends StatelessWidget {
  const InventoryZone({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        clipBehavior: Clip.none,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InventoryField(
            sideSize: height - 20 - 35,
            capacity: Inventory.defaultCapacity,
          ),
        )));
  }
}
