import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/enemy_picker/components/horizontal_list_wheel_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnemyPicker extends StatelessWidget {
  const EnemyPicker({super.key, required this.controllerEnemy, required this.constraints});

  final FixedExtentScrollController controllerEnemy;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: constraints.maxHeight / 5,
            child: HorizontalListWheelScrollView(
              controller: controllerEnemy,
              childCount: 3,
              scrollDirection: Axis.horizontal,
              itemExtent: 150,
              onSelectedItemChanged: (index) {
                /// TODO: Надо будет исправить, сейчас всегда только оборотень
                huntingFieldsBloc.add(HuntingFieldEvent$SelectEnemy(enemy: stockWerewolf));
              },
              builder: (BuildContext context, int index) {
                return Container(
                    height: constraints.maxHeight / 5,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(8),
                    decoration: inventorySlotDecoration,
                    child: index == 0

                        /// TODO: Надо будет исправить, сейчас всегда только оборотень
                        ? Image.asset(stockWerewolf.image)
                        : const SizedBox());
              },
            ),
          ),
        ),
      ],
    );
  }
}
