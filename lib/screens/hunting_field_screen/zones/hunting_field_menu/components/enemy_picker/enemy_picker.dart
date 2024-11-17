import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/components/enemy_picker/components/horizontal_list_wheel_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnemyPicker extends StatelessWidget {
  const EnemyPicker(
      {super.key, required this.controllerEnemy, required this.constraints});

  final FixedExtentScrollController controllerEnemy;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();

    return Row(
      children: [
        InkWell(
            onTap: () {
              if (controllerEnemy.selectedItem > 0) {
                controllerEnemy.animateToItem(
                    controllerEnemy.selectedItem - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 80,
              color: Colors.yellow,
            )),
        Expanded(
          child: SizedBox(
            height: constraints.maxHeight / 4,
            child: HorizontalListWheelScrollView(
              controller: controllerEnemy,
              childCount: 3,
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              onSelectedItemChanged: (index) {
                /// TODO: Надо будет исправить, сейчас всегда только оборотень
                huntingFieldsBloc.add(
                    HuntingFieldEvent$SelectEnemy(enemy: stockWerewolf));
              },
              builder: (BuildContext context, int index) {
                return Container(
                    height: constraints.maxHeight / 4,
                    margin: const EdgeInsets.all(16),
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
        InkWell(
            onTap: () {
              if (controllerEnemy.selectedItem < 3) {
                controllerEnemy.animateToItem(
                    controllerEnemy.selectedItem + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            },
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 80,
              color: Colors.yellow,
            )),
      ],
    );
  }
}
