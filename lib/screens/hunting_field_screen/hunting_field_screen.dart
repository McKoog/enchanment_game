import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/hunting_field_menu.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/enemy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldScreen extends StatelessWidget {
  const HuntingFieldScreen({super.key, this.width});

  /// If provided, uses this fixed width. Otherwise, fills available space.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final effectiveWidth = width ?? constraints.maxWidth;
      return BlocProvider(
        create: (context) => HuntingFieldsBloc(
            initialEnemy: stockWerewolf, initialWeapon: ItemRegistry.fist),
        child: Builder(builder: (context) {
          final huntingBloc = context.read<HuntingFieldsBloc>();

          void syncSelectedWeapon(Inventory inventory) {
            final current = huntingBloc.state.selectedWeapon;
            final resolved = _resolveWeaponFromInventory(
                inventory: inventory, currentWeapon: current);
            if (!identical(resolved, current)) {
              huntingBloc.add(HuntingFieldEvent$SelectWeapon(weapon: resolved));
            }
          }

          return BlocListener<InventoryBloc, InventoryState>(
            listener: (context, inventoryState) {
              syncSelectedWeapon(inventoryState.inventory);
            },
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, inventoryState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  syncSelectedWeapon(inventoryState.inventory);
                });

                return BlocBuilder<HuntingFieldsBloc, HuntingFieldState>(
                    bloc: huntingBloc,
                    builder: (context, state) {
                      return state is HuntingFieldState$HuntingStarted
                          ? EnemyPage(
                              width: effectiveWidth,
                              enemy: state.selectedEnemy,
                              weapon: state.selectedWeapon,
                            )
                          : HuntingFieldsMenu(
                              constraints: constraints, width: effectiveWidth);
                    });
              },
            ),
          );
        }),
      );
    }));
  }
}

Weapon _resolveWeaponFromInventory(
    {required Inventory inventory, required Weapon currentWeapon}) {
  if (currentWeapon.id == ItemRegistry.fist.id) return ItemRegistry.fist;

  for (final Item? item in inventory.items) {
    if (item is Weapon && item.id == currentWeapon.id) {
      return item;
    }
  }

  return ItemRegistry.fist;
}
