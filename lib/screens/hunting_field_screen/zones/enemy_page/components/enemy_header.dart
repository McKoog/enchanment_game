import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart' show HuntingFieldsBloc;
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnemyHeader extends StatelessWidget {
  const EnemyHeader({
    super.key,
    required this.width,
    required this.enemy,
    this.heightFactor = 80,
    required this.onTitleTap,
  });

  final double width;
  final Enemy enemy;
  final VoidCallback onTitleTap;

  /// Available height for this header section.
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    // Scale internal sizes proportionally to the available height.
    // Reference height = 80 (original design).
    final double scale = (heightFactor / 80).clamp(0.4, 1.5);
    final double iconSize = 40 * scale;
    final double nameFieldHeight = 53 * scale;

    final escapeTime = context.read<CharacterBloc>().state.character.escapeCooldownEndTime;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: heightFactor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                              onTap: onTitleTap,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: nameFieldHeight,
                                  decoration: AppDecorations.darkGlowBorder,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          enemy.name,
                                          style: AppTypography.titleMediumHighlight,
                                        ),
                                        Text(
                                          "show droplist",
                                          style: AppTypography.attributeLabel.copyWith(color: AppColors.accentYellow),
                                        ),
                                      ],
                                    ),
                                  )))),
                    ],
                  ),
                  if (escapeTime != null && DateTime.now().isAfter(escapeTime) || escapeTime == null)
                    Positioned(
                      top: 6,
                      right: 1,
                      child: InkWell(
                          onTap: () {
                            context.read<HuntingFieldsBloc>().add(HuntingFieldEvent$StopHunting());
                          },
                          child: Icon(
                            Icons.close,
                            size: iconSize,
                            color: AppColors.accentYellow,
                          )),
                    ),
                ],
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8),
        //   child: InkWell(
        //       onTap: () {
        //         context.read<HuntingFieldsBloc>().add(HuntingFieldEvent$StopHunting());
        //       },
        //       child: Icon(
        //         Icons.close,
        //         size: iconSize,
        //         color: Colors.yellow,
        //       )),
        // ),
      ],
    );
  }
}
