import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PickedMonsterField extends ConsumerWidget {
  const PickedMonsterField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    Monster? selectedMonster = ref.watch(currentSelectedMonsterHuntingField);
    return selectedMonster != null
        ? InkWell(
      onTap: () {
        ref
            .read(showHuntMonsterPage.notifier)
            .update((state) => true);
      },
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 60,
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/hunt_button_icon.svg",
              height: 50,
              color: Colors.yellow,
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: huntBeginButtonDecoration,
                    child: Text(
                      "Hunt ${selectedMonster.name}",
                      style: huntingBeginButtonTextDecoration,
                    ))),
            SvgPicture.asset(
              "assets/hunt_button_icon.svg",
              height: 50,
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    )
        : SizedBox(
        height: 80, width: MediaQuery.of(context).size.width - 60);
  }
}
