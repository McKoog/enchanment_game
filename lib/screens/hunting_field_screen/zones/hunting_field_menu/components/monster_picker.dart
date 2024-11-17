import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/game_stock_data/stock_monsters.dart';
import 'package:enchantment_game/own_packages/HorizonalListWheelScrollView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonsterPicker extends StatelessWidget {
  const MonsterPicker(
      {super.key, required this.controllerMonster, required this.constraints});

  final FixedExtentScrollController controllerMonster;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();

    return Row(
      children: [
        InkWell(
            onTap: () {
              if (controllerMonster.selectedItem > 0) {
                controllerMonster.animateToItem(
                    controllerMonster.selectedItem - 1,
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
              controller: controllerMonster,
              childCount: 3,
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              onSelectedItemChanged: (index) {
                /// TODO: Надо будет исправить, сейчас всегда только оборотень
                huntingFieldsBloc.add(
                    HuntingFieldEvent$SelectMonster(monster: stockWerewolf));
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
              if (controllerMonster.selectedItem < 3) {
                controllerMonster.animateToItem(
                    controllerMonster.selectedItem + 1,
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
