import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        "Shop will add soon...",
        style: huntFieldNameTextDecoration,
      ),
    );
  }
}
