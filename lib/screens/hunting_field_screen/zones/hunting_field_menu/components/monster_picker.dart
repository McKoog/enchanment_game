import 'package:enchantment_game/data_providers/all_monsters_list.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/own_packages/HorizonalListWheelScrollView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonsterPicker extends ConsumerWidget {
  const MonsterPicker({Key? key,required this.controllerMonster,required this.constraints}) : super(key: key);

  final FixedExtentScrollController controllerMonster;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

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
            //color: Color.fromRGBO(85, 85, 85, 1).withOpacity(0.5),
            child: HorizontalListWheelScrollView(
              controller: controllerMonster,
              childCount: 3,
              //ref.read(allMonstersList).length,
              scrollDirection: Axis.horizontal,
              itemExtent: 200,
              onSelectedItemChanged: (index) {
                ref
                    .read(currentSelectedMonsterHuntingField.notifier)
                    .update((state) => index == 0
                    ? ref.read(allMonstersList)[0]
                    : null);
              },
              builder: (BuildContext context, int index) {
                return Container(
                    height: constraints.maxHeight / 4,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(8),
                    decoration: inventorySlotDecoration,
                    child: index == 0
                        ? Image.asset(
                        ref.read(allMonstersList)[index].image)
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
