import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/visual_settings_bloc/visual_settings_bloc.dart';
import 'package:enchantment_game/game_stock_data/stock_inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedBlocsProvider extends StatelessWidget {
  const SharedBlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => InventoryBloc(initialInventory: stockInventory)),
      BlocProvider(
        create: (context) => VisualSettingsBloc(),
      ),
      BlocProvider(
        create: (context) => CharacterBloc(),
      ),
      BlocProvider(
        create: (context) => DraggableItemsBloc(),
      ),
    ], child: child);
  }
}
