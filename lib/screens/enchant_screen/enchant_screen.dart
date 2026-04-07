import 'package:enchantment_game/blocs/item_info_bloc/item_info_bloc.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/enchant_zone/enchant_zone.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/inventory_zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnchantScreen extends StatelessWidget {
  const EnchantScreen({super.key, this.width});

  /// If provided, uses this fixed width. Otherwise, fills available space.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final effectiveWidth = width ?? constraints.maxWidth;
      return BlocProvider(
        create: (context) => ItemInfoBloc(),
        child: SizedBox(
          width: effectiveWidth,
          child: Column(children: [
            EnchantZone(
                height: constraints.maxHeight / 2, width: effectiveWidth),
            InventoryZone(
                height: constraints.maxHeight / 2, width: effectiveWidth)
          ]),
        ),
      );
    }));
  }
}
