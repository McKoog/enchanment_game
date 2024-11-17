import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

class PickedEnemyField extends StatelessWidget {
  const PickedEnemyField({super.key});

  @override
  Widget build(BuildContext context) {
    final huntingFieldsBloc = context.read<HuntingFieldsBloc>();
    Enemy? selectedEnemy = huntingFieldsBloc.state.selectedEnemy;
    return InkWell(
      onTap: () {
        huntingFieldsBloc.add(HuntingFieldEvent$StartHunting());
      },
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 60,
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/hunt_button_icon.svg",
              height: 50,
              colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: huntBeginButtonDecoration,
                    child: Text(
                      "Hunt ${selectedEnemy.name}",
                      style: huntingBeginButtonTextDecoration,
                    ))),
            SvgPicture.asset(
              "assets/hunt_button_icon.svg",
              height: 50,
              colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
