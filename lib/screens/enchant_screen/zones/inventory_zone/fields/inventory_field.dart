import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryField extends StatelessWidget {
  const InventoryField(
      {super.key, required this.sideSize, required this.capacity});

  final double sideSize;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: sideSize,
        width: sideSize,
        //decoration: inventoryZoneDecoration,
        child: BlocBuilder<InventoryBloc, InventoryState>(
            bloc: context.read<InventoryBloc>(),
            builder: (BuildContext context, state) {
              return BlocBuilder<DraggableItemsBloc, DraggableItemsState>(
                  bloc: context.read<DraggableItemsBloc>(),
                  builder: (context, dragState) {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: capacity,
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        itemBuilder: (BuildContext context, int index) {
                          return InventorySlot(
                            index: index,
                            item: state.inventory.items[index],
                          );
                        });
                  });
            }));
  }
}
