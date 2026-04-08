import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_bloc.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_event.dart';
import 'package:enchantment_game/blocs/hunting_fields_bloc/hunting_fields_state.dart';
import 'package:enchantment_game/blocs/character_bloc/character_bloc.dart';
import 'package:enchantment_game/blocs/character_bloc/character_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/game_stock_data/stock_enemies.dart';
import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/enemy_page.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/hunting_field_menu/hunting_field_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HuntingFieldScreen extends StatefulWidget {
  const HuntingFieldScreen({super.key, this.width});

  /// If provided, uses this fixed width. Otherwise, fills available space.
  final double? width;

  @override
  State<HuntingFieldScreen> createState() => _HuntingFieldScreenState();
}

class _HuntingFieldScreenState extends State<HuntingFieldScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache all backgrounds and enemies for instant toggling
    precacheImage(
        const AssetImage('assets/background/forest_background.png'), context);
    precacheImage(
        const AssetImage('assets/background/forest_enemy_background.png'),
        context);
    precacheImage(const AssetImage('assets/icons/enemies/wolf.png'), context);
    precacheImage(const AssetImage('assets/icons/enemies/bandit.png'), context);
    precacheImage(const AssetImage('assets/icons/enemies/goblin.png'), context);
    precacheImage(const AssetImage('assets/icons/enemies/dryad.png'), context);
    precacheImage(
        const AssetImage('assets/icons/enemies/lvl_1_werewolf.png'), context);

    // Precache other icons
    precacheImage(
        const AssetImage('assets/icons/slot_slider_icon.png'), context);

    // Precache all item images
    for (final imagePath in ItemRegistry.allImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HuntingFieldsBloc(
          initialEnemy: stockWerewolf, initialWeapon: ItemRegistry.fist),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final effectiveWidth = widget.width ?? constraints.maxWidth;
        return Builder(builder: (context) {
          final huntingBloc = context.read<HuntingFieldsBloc>();

          void syncSelectedWeapon(Character character) {
            final current = huntingBloc.state.selectedWeapon;
            final resolved = character.equippedWeapon ?? ItemRegistry.fist;
            if (!identical(resolved, current)) {
              huntingBloc.add(HuntingFieldEvent$SelectWeapon(weapon: resolved));
            }
          }

          return BlocListener<CharacterBloc, CharacterState>(
            listener: (context, characterState) {
              syncSelectedWeapon(characterState.character);
            },
            child: BlocBuilder<CharacterBloc, CharacterState>(
              builder: (context, characterState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  syncSelectedWeapon(characterState.character);
                });

                return BlocBuilder<HuntingFieldsBloc, HuntingFieldState>(
                    bloc: huntingBloc,
                    builder: (context, state) {
                      final isHunting =
                          state is HuntingFieldState$HuntingStarted;
                      return Stack(
                        children: [
                          Offstage(
                            offstage: isHunting,
                            child: HuntingFieldsMenu(
                                constraints: constraints,
                                width: effectiveWidth),
                          ),
                          if (isHunting)
                            EnemyPage(
                              width: effectiveWidth,
                              enemy: state.selectedEnemy,
                              weapon: state.selectedWeapon,
                            ),
                        ],
                      );
                    });
              },
            ),
          );
        });
      }),
    );
  }
}
