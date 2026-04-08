import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/decorations/bottons_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

class EnemyHeader extends StatelessWidget {
  const EnemyHeader({
    super.key,
    required this.width,
    required this.enemy,
    this.heightFactor = 80,
  });

  final double width;
  final Enemy enemy;

  /// Available height for this header section.
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    // Scale internal sizes proportionally to the available height.
    // Reference height = 80 (original design).
    final double scale = (heightFactor / 80).clamp(0.4, 1.5);
    final double iconSize = 40 * scale;
    final double svgHeight = 50 * scale;
    final double nameFieldHeight = 53 * scale;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
              onTap: () {
                context
                    .read<HuntingFieldsBloc>()
                    .add(HuntingFieldEvent$StopHunting());
              },
              child: Icon(
                Icons.arrow_back,
                size: iconSize,
                color: Colors.yellow,
              )),
        ),
        Expanded(
          child: SizedBox(
            height: heightFactor,
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/hunt_button_icon.svg",
                  height: svgHeight,
                  colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        height: nameFieldHeight,
                        decoration: enemyNameFieldDecoration,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                enemy.name,
                                style: farmEnemyNameTextDecoration,
                              ),
                              const Text(
                                "show droplist",
                                style: TextStyle(color: Colors.yellow),
                              ),
                            ],
                          ),
                        ))),
                SvgPicture.asset(
                  "assets/hunt_button_icon.svg",
                  height: svgHeight,
                  colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_forward,
            size: iconSize,
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }
}
