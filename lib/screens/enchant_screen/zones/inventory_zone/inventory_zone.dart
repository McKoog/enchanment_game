import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/inventory_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryZone extends StatelessWidget {
  const InventoryZone({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DraggableItemsBloc>(
      create: (context) => DraggableItemsBloc(),
      child: SizedBox(
          height: height,
          width: width,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InventoryField(
              sideSize: height - 20,
              capacity: 25,
            ),
          ))),
    );
  }
}
