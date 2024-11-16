import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({final Inventory? initialInventory})
      : super(initialInventory != null
            ? InventoryState$Ready(inventory: initialInventory)
            : InventoryState$Initial());
}
