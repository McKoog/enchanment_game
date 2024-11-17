import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/game_stock_data/game_stock_items.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/hunting_field_menu.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/enemy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldScreen extends StatelessWidget {
  const HuntingFieldScreen({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return BlocProvider(
        create: (context) => HuntingFieldsBloc(
            initialEnemy: stockWerewolf, initialWeapon: stockFist),
        child: Builder(builder: (context) {
          return BlocBuilder<HuntingFieldsBloc, HuntingFieldState>(
              bloc: context.read<HuntingFieldsBloc>(),
              builder: (context, state) {
                return state is HuntingFieldState$HuntingStarted
                    ? EnemyPage(
                        width: width,
                        enemy: state.selectedEnemy,
                        weapon: state.selectedWeapon,
                      )
                    : HuntingFieldsMenu(constraints: constraints, width: width);
              });
        }),
      );
    }));
  }
}
