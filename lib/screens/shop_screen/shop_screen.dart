import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, this.width});

  /// If provided, uses this fixed width. Otherwise, fills available space.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth = width ?? constraints.maxWidth;
        return Container(
          width: effectiveWidth,
          alignment: Alignment.center,
          child: Text(
            "Shop will add soon...",
            style: huntFieldNameTextDecoration,
          ),
        );
      },
    );
  }
}
