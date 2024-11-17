import 'dart:convert';

import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_event.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/data_providers/shared_pref_provider.dart';
import 'package:enchantment_game/decorations/zone_decorations.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryField extends ConsumerWidget {
  const InventoryField(
      {super.key, required this.sideSize, required this.capacity});

  final double sideSize;
  final int capacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        height: sideSize,
        width: sideSize,
        //decoration: inventoryZoneDecoration,
        child: BlocBuilder<InventoryBloc, InventoryState>(
          bloc: context.read<InventoryBloc>(),
          builder: (BuildContext context, state) {
                return BlocBuilder<DraggableItemsBloc,DraggableItemsState>(
                  bloc: context.read<DraggableItemsBloc>(),
                  builder: (context,dragState) {
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
                  }
                );
            }
        ));
  }
}
